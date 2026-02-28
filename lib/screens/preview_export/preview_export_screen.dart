import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/text_renderer.dart';
import '../../data/models/background_item.dart';
import '../../data/services/video_export_service.dart';
import '../../data/services/stats_service.dart';
import '../../state/reel_provider.dart';
import '../shared/reel_preview_card.dart';
import '../shared/step_indicator.dart';
import 'widgets/export_progress_overlay.dart';
import 'widgets/export_success_sheet.dart';

class PreviewExportScreen extends ConsumerStatefulWidget {
  const PreviewExportScreen({super.key});

  @override
  ConsumerState<PreviewExportScreen> createState() =>
      _PreviewExportScreenState();
}

class _PreviewExportScreenState extends ConsumerState<PreviewExportScreen> {
  bool _exporting = false;
  bool _exportingImage = false;
  ExportProgress? _progress;
  String? _exportedPath;
  String? _error;

  Future<void> _startExport() async {
    setState(() {
      _exporting = true;
      _error = null;
      _exportedPath = null;
    });

    try {
      final path = await VideoExportService().exportVideo(
        state: ref.read(reelProvider),
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );
      if (!mounted) return;

      setState(() {
        _progress = const ExportProgress(
          phase: ExportPhase.savingToGallery,
          label: 'Saving to gallery',
          progress: 0.95,
        );
      });
      await Gal.putVideo(path, album: 'TaqwaReels');

      if (!mounted) return;

      setState(() {
        _exporting = false;
        _exportedPath = path;
        _progress = const ExportProgress(
          phase: ExportPhase.done,
          label: 'Complete!',
          progress: 1.0,
        );
      });
      showExportSuccessSheet(context, ref, _exportedPath);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _exporting = false;
        _error = e.toString();
      });
    }
  }

  /// Export the current slide as a single PNG image.
  Future<void> _saveAsImage() async {
    setState(() {
      _exportingImage = true;
      _error = null;
    });

    try {
      final state = ref.read(reelProvider);
      final slide = state.slides[state.currentSlideIndex];
      final opts = state.exportOptions;
      final w = opts.width;
      final h = opts.height;

      // Get tmp path
      final tmpDir = Directory.systemTemp.path;
      final imgDir = '$tmpDir/taqwa_image_export';
      await Directory(imgDir).create(recursive: true);

      // 1. Draw background onto canvas
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()));

      // Background color
      Color bgColor;
      if (state.background?.type == BackgroundType.solidColor) {
        final hex = state.background!.solidColorHex ?? '#0A0E1A';
        bgColor = Color(int.parse(hex.replaceFirst('#', '0xFF')));
      } else {
        bgColor = const Color(0xFF0A0E1A);
      }
      canvas.drawRect(
        Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
        Paint()..color = bgColor,
      );

      // Dim overlay
      canvas.drawRect(
        Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
        Paint()..color = Colors.black.withAlpha((state.dimOpacity * 255).round()),
      );

      final bgPicture = recorder.endRecording();
      final bgImage = await bgPicture.toImage(w, h);
      final bgByteData = await bgImage.toByteData(format: ui.ImageByteFormat.png);
      bgImage.dispose();
      final bgPngPath = '$imgDir/bg.png';
      await File(bgPngPath).writeAsBytes(bgByteData!.buffer.asUint8List());

      // 2. Render text overlay
      final textPngPath = await TextRenderer.renderSlide(
        slide: slide,
        state: state,
        width: w,
        height: h,
        outputPath: '$imgDir/text.png',
      );

      // 3. Composite: bg + text overlay
      // Load both as images then paint overlay on top
      final bgBytes = await File(bgPngPath).readAsBytes();
      final textBytes = await File(textPngPath).readAsBytes();

      final bgCodec = await ui.instantiateImageCodec(bgBytes);
      final bgFrame = await bgCodec.getNextFrame();
      final textCodec = await ui.instantiateImageCodec(textBytes);
      final textFrame = await textCodec.getNextFrame();

      final finalRecorder = ui.PictureRecorder();
      final finalCanvas = Canvas(finalRecorder, Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()));
      finalCanvas.drawImage(bgFrame.image, Offset.zero, Paint());
      finalCanvas.drawImage(textFrame.image, Offset.zero, Paint());
      final finalPicture = finalRecorder.endRecording();
      final finalImage = await finalPicture.toImage(w, h);
      final finalByteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
      finalImage.dispose();
      bgFrame.image.dispose();
      textFrame.image.dispose();

      final outputPath = '$imgDir/taqwa_slide_${state.currentSlideIndex}.png';
      await File(outputPath).writeAsBytes(finalByteData!.buffer.asUint8List());

      // Save to gallery
      await Gal.putImage(outputPath, album: 'TaqwaReels');
      StatsService.incrementImages();

      if (!mounted) return;
      setState(() => _exportingImage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to gallery!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _exportingImage = false;
        _error = 'Image export failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reelProvider);
    final slides = state.slides;
    final idx = state.currentSlideIndex;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview & Export'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: _exporting ? null : () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: StepIndicator(current: 4),
                ),

                // Slide navigator
                _buildSlideNav(idx, slides.length),

                // Preview
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.sm,
                    ),
                    child: ReelPreviewCard(),
                  ),
                ),

                // Error
                if (_error != null) _buildError(),

                // Action buttons
                _buildActions(),
              ],
            ),
            if (_exporting) ExportProgressOverlay(progress: _progress),
          ],
        ),
      ),
    );
  }

  // ── Small inline helpers ──

  Widget _buildSlideNav(int idx, int total) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.xs,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: idx > 0
              ? () => ref.read(reelProvider.notifier).prevSlide()
              : null,
          icon: Icon(
            Icons.chevron_left_rounded,
            color: idx > 0 ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Text(
            'Segment ${idx + 1} / $total',
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: idx < total - 1
              ? () => ref.read(reelProvider.notifier).nextSlide()
              : null,
          icon: Icon(
            Icons.chevron_right_rounded,
            color: idx < total - 1
                ? AppColors.textPrimary
                : AppColors.textMuted,
          ),
        ),
      ],
    ),
  );

  Widget _buildError() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(25),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildActions() => Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _exporting ? null : _startExport,
            icon: const Icon(Icons.movie_creation_rounded),
            label: const Text('Export Reel'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: (_exporting || _exportingImage) ? null : _saveAsImage,
            icon: _exportingImage
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  )
                : Icon(
                    Icons.image_rounded,
                    color: AppColors.primary,
                  ),
            label: Text(
              _exportingImage ? 'Saving...' : 'Save Current Slide as Image',
              style: TextStyle(color: AppColors.primary),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primaryDim),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _exportedPath != null
                ? () async {
                    await SharePlus.instance.share(
                      ShareParams(files: [XFile(_exportedPath!)]),
                    );
                  }
                : null,
            icon: Icon(
              Icons.share_rounded,
              color: _exportedPath != null
                  ? AppColors.primary
                  : AppColors.textMuted,
            ),
            label: Text(
              'Share',
              style: TextStyle(
                color: _exportedPath != null
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primaryDim),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

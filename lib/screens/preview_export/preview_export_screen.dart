import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/services/video_export_service.dart';
import '../../state/reel_provider.dart';
import '../shared/reel_preview_card.dart';

class PreviewExportScreen extends ConsumerStatefulWidget {
  const PreviewExportScreen({super.key});

  @override
  ConsumerState<PreviewExportScreen> createState() =>
      _PreviewExportScreenState();
}

class _PreviewExportScreenState extends ConsumerState<PreviewExportScreen> {
  bool _exporting = false;
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

      // Save to gallery
      setState(() {
        _progress = const ExportProgress(
          phase: ExportPhase.savingToGallery,
          label: 'Saving to gallery',
          progress: 0.95,
        );
      });
      await Gal.putVideo(path, album: 'TaqwaReels');

      setState(() {
        _exporting = false;
        _exportedPath = path;
        _progress = const ExportProgress(
          phase: ExportPhase.done,
          label: 'Complete!',
          progress: 1.0,
        );
      });
      _showSuccessSheet();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _exporting = false;
        _error = e.toString();
      });
    }
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Reel Exported! 🎬',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your video has been saved to gallery',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (_exportedPath != null) {
                        await Share.shareXFiles([XFile(_exportedPath!)]);
                      }
                    },
                    icon: const Icon(
                      Icons.share_rounded,
                      color: AppColors.primary,
                    ),
                    label: const Text(
                      'Share',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primaryDim),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(reelProvider.notifier).reset();
                      context.go('/');
                    },
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('Home'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reelProvider);
    final slides = state.slides;
    final currentIndex = state.currentSlideIndex;

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
            // Main content
            Column(
              children: [
                // Step indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: _buildStepIndicator(4),
                ),

                // Slide navigator
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: currentIndex > 0
                            ? () => ref.read(reelProvider.notifier).prevSlide()
                            : null,
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: currentIndex > 0
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                        ),
                        child: Text(
                          'Segment ${currentIndex + 1} / ${slides.length}',
                          style: GoogleFonts.outfit(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: currentIndex < slides.length - 1
                            ? () => ref.read(reelProvider.notifier).nextSlide()
                            : null,
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: currentIndex < slides.length - 1
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Preview card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.sm,
                    ),
                    child: const ReelPreviewCard(),
                  ),
                ),

                // Error message
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.error.withAlpha(25),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Buttons
                Padding(
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
                          onPressed: _exportedPath != null
                              ? () async {
                                  await Share.shareXFiles([
                                    XFile(_exportedPath!),
                                  ]);
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
                ),
              ],
            ),

            // ── Export Progress Overlay ──
            if (_exporting) _buildProgressOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverlay() {
    final p = _progress;
    return Container(
      color: Colors.black.withAlpha(200),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.xl),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(30),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Phase label
              Text(
                p?.label ?? 'Preparing...',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              if (p?.detail != null)
                Text(
                  p!.detail!,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(height: AppSpacing.md),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: p?.progress ?? 0,
                  backgroundColor: AppColors.bgCardLight,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${((p?.progress ?? 0) * 100).round()}%',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final isActive = i < current;
        final isCurrent = i == current - 1;
        return Row(
          children: [
            Container(
              width: isCurrent ? 28 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            if (i < 3) const SizedBox(width: 6),
          ],
        );
      }),
    );
  }
}

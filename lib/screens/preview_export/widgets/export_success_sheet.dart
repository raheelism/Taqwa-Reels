import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../state/reel_provider.dart';

/// Bottom sheet shown after a successful video export.
void showExportSuccessSheet(
  BuildContext context,
  WidgetRef ref,
  String? exportedPath,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _SuccessSheetContent(path: exportedPath, ref: ref),
  );
}

class _SuccessSheetContent extends StatefulWidget {
  final String? path;
  final WidgetRef ref;

  const _SuccessSheetContent({required this.path, required this.ref});

  @override
  State<_SuccessSheetContent> createState() => _SuccessSheetContentState();
}

class _SuccessSheetContentState extends State<_SuccessSheetContent> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.path != null) {
      _controller = VideoPlayerController.file(File(widget.path!))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _controller!.setLooping(true);
            _controller!.play();
          }
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
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

          // Video Player
          if (_controller != null && _controller!.value.isInitialized)
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.bgCardLight, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
            ),
          if (_controller != null && _controller!.value.isInitialized)
            const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (widget.path != null) {
                      await Share.shareXFiles([XFile(widget.path!)]);
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
                    widget.ref.read(reelProvider.notifier).reset();
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
    );
  }
}

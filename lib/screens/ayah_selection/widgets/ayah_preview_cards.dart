import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/reel_slide.dart';

/// Horizontal PageView preview cards showing each slide's Arabic + translation.
class AyahPreviewCards extends StatelessWidget {
  final List<ReelSlide> slides;
  final int currentIndex;
  final bool isPlaying;
  final int? playingAyah;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onToggleAudio;

  const AyahPreviewCards({
    super.key,
    required this.slides,
    required this.currentIndex,
    required this.isPlaying,
    required this.playingAyah,
    required this.onPageChanged,
    required this.onToggleAudio,
  });

  @override
  Widget build(BuildContext context) {
    if (slides.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: slides.length,
        controller: PageController(viewportFraction: 0.92),
        onPageChanged: onPageChanged,
        itemBuilder: (_, i) => _SlideCard(
          slide: slides[i],
          isActive: i == currentIndex,
          isPlaying: isPlaying && playingAyah == slides[i].ayahNumber,
          onTapAudio: () => onToggleAudio(slides[i].ayahNumber),
        ),
      ),
    );
  }
}

class _SlideCard extends StatelessWidget {
  final ReelSlide slide;
  final bool isActive;
  final bool isPlaying;
  final VoidCallback onTapAudio;

  const _SlideCard({
    required this.slide,
    required this.isActive,
    required this.isPlaying,
    required this.onTapAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withAlpha(120)
              : AppColors.bgCardLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  slide.slideLabel,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      final text = '${slide.arabicText}\n\n${slide.translationText}\n\n— ${slide.slideLabel}';
                      Clipboard.setData(ClipboardData(text: text));
                      // Find the nearest ScaffoldMessenger
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ayah copied to clipboard'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: const BoxDecoration(
                        color: AppColors.bgCardLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              GestureDetector(
                onTap: onTapAudio,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? AppColors.primary
                        : AppColors.bgCardLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                    size: 16,
                    color: isPlaying ? AppColors.bg : AppColors.textSecondary,
                  ),
                ),
              ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Arabic
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                slide.arabicText,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  fontSize: 17,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Translation
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                slide.translationText,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

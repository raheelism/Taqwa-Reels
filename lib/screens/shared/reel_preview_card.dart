import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/background_item.dart';
import '../../state/reel_provider.dart';

/// Shared live preview card used on both the Customize and Preview screens.
/// Shows the background (image), dim overlay, and styled Arabic/translation text
/// at the configured position.
class ReelPreviewCard extends ConsumerWidget {
  const ReelPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reelProvider);
    final slide = ref.watch(currentSlideProvider);
    if (slide == null) {
      return AspectRatio(
        aspectRatio: 9 / 16,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'No segments loaded',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
        ),
      );
    }

    final textColor = Color(
      int.parse(state.textColor.replaceFirst('#', '0xFF')),
    );
    final yFrac = state.textPosition; // 0.0 top → 1.0 bottom

    return AspectRatio(
      aspectRatio: 9 / 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background
            if (state.background != null)
              state.background!.type == BackgroundType.image
                  ? CachedNetworkImage(
                      imageUrl: state.background!.fullUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.bgCard),
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.bgCard),
                    )
                  : CachedNetworkImage(
                      imageUrl: state.background!.previewUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.bgCard),
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.bgCard),
                    )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A2040), Color(0xFF0A0E1A)],
                  ),
                ),
              ),

            // Dim overlay
            Container(
              color: Colors.black.withAlpha((state.dimOpacity * 255).round()),
            ),

            // Positioned text with ScrollView to prevent UI overflow
            Align(
              alignment: Alignment(0, (yFrac * 2) - 1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Arabic text
                      Text(
                        slide.arabicText,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          state.font.googleFontFamily,
                          fontSize: state.fontSize,
                          color: textColor,
                          height: 1.8,
                          shadows: state.showArabicShadow
                              ? [
                                  const Shadow(
                                    blurRadius: 8,
                                    color: Colors.black87,
                                  ),
                                ]
                              : null,
                        ),
                      ),

                      // Translation
                      if (state.showTranslation) ...[
                        const SizedBox(height: 12),
                        Text(
                          slide.translationText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: state.fontSize * 0.52,
                            color: textColor.withAlpha(217),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],

                      // Slide label
                      const SizedBox(height: 8),
                      Text(
                        slide.slideLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withAlpha(153),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Watermark (top center)
            if (state.watermarkText.isNotEmpty)
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: Text(
                  state.watermarkText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white.withAlpha(200),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    shadows: [
                      const Shadow(blurRadius: 4, color: Colors.black54),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

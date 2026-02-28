import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/background_item.dart';
import '../../data/models/export_options.dart';
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
    final ratio = state.exportOptions.width / state.exportOptions.height;

    if (slide == null) {
      return AspectRatio(
        aspectRatio: ratio,
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
      aspectRatio: ratio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // How text_renderer calculates scale: scale = outputWidth / 360.0
            // Here, our UI "360 base" is actually represented by the widget's constraints.maxWidth
            final scale = constraints.maxWidth / 360.0;

            return Stack(
              fit: StackFit.expand,
              children: [
                // Background (with optional blur preview)
                _buildBackground(state, state.exportOptions.backgroundBlur),

                // Dim overlay
                Container(
                  color: Colors.black.withAlpha(
                    (state.dimOpacity * 255).round(),
                  ),
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
                              fontSize: state.fontSize * scale,
                              color: textColor,
                              height: 1.8,
                              shadows: state.showArabicShadow
                                  ? [
                                      Shadow(
                                        blurRadius: 4 * scale,
                                        color: Colors.black87,
                                        offset: Offset(3 * scale, 3 * scale),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),

                          // Translation
                          if (state.showTranslation) ...[
                            SizedBox(height: 12 * scale),
                            Text(
                              slide.translationText,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: state.fontSize *
                                    state.exportOptions.translationFontScale *
                                    scale,
                                color: textColor.withAlpha(217),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],

                          // Slide label
                          SizedBox(height: 8 * scale),
                          Text(
                            slide.slideLabel,
                            style: TextStyle(
                              fontSize: 12 * scale,
                              color: textColor.withAlpha(153),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Watermark
                if (state.watermarkText.isNotEmpty &&
                    state.exportOptions.watermarkPosition !=
                        WatermarkPosition.hidden)
                  Positioned(
                    top: state.exportOptions.watermarkPosition ==
                            WatermarkPosition.topCenter
                        ? 24 * scale
                        : null,
                    bottom: state.exportOptions.watermarkPosition ==
                            WatermarkPosition.bottomCenter
                        ? 24 * scale
                        : null,
                    left: 0,
                    right: 0,
                    child: Text(
                      state.watermarkText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: state.exportOptions.watermarkFontSize * scale,
                        color: Colors.white.withAlpha(
                          (state.exportOptions.watermarkOpacity * 255).round(),
                        ),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                              blurRadius: 4 * scale,
                              color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Background widget with optional blur applied via ImageFilter.
  Widget _buildBackground(dynamic state, double blurRadius) {
    Widget bg;
    if (state.background != null) {
      if (state.background!.type == BackgroundType.solidColor) {
        // Solid color background
        final hex = state.background!.solidColorHex ?? '#0A0E1A';
        final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
        bg = Container(color: color);
      } else if (state.background!.type == BackgroundType.image) {
        bg = CachedNetworkImage(
            imageUrl: state.background!.fullUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppColors.bgCard),
            errorWidget: (_, __, ___) => Container(color: AppColors.bgCard),
          );
      } else {
        bg = CachedNetworkImage(
            imageUrl: state.background!.previewUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppColors.bgCard),
            errorWidget: (_, __, ___) => Container(color: AppColors.bgCard),
          );
      }
    } else {
      bg = Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2040), Color(0xFF0A0E1A)],
          ),
        ),
      );
    }

    if (blurRadius > 0) {
      return ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: blurRadius * 0.5,
          sigmaY: blurRadius * 0.5,
          tileMode: TileMode.clamp,
        ),
        child: bg,
      );
    }
    return bg;
  }
}

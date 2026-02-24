import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/reel_slide.dart';
import '../../state/reel_state.dart';

/// Renders slide text to transparent PNG images using Flutter's text engine.
/// This guarantees proper Arabic shaping, RTL, and ligatures — matching
/// the in-app preview exactly.
class TextRenderer {
  /// Render a single slide's text overlay as a transparent PNG.
  /// The output image is [width]×[height] with only text painted on
  /// a fully transparent background.
  static Future<String> renderSlide({
    required ReelSlide slide,
    required ReelState state,
    required int width,
    required int height,
    required String outputPath,
  }) async {
    final w = width.toDouble();
    final h = height.toDouble();
    final scale = w / 360.0; // match preview sizing

    final textColor = _parseColor(state.textColor);

    // ── Prepare text styles (scaled to video resolution) ──
    final arStyle = GoogleFonts.getFont(
      state.font.googleFontFamily,
      fontSize: state.fontSize * scale,
      color: textColor,
      height: 1.8,
      shadows: state.showArabicShadow
          ? [
              Shadow(
                color: Colors.black.withAlpha(180),
                blurRadius: 4 * scale,
                offset: Offset(3 * scale, 3 * scale),
              ),
            ]
          : null,
    );

    final trStyle = GoogleFonts.outfit(
      fontSize: state.fontSize * 0.52 * scale,
      color: textColor.withAlpha(217),
      fontStyle: FontStyle.italic,
    );

    final refStyle = GoogleFonts.outfit(
      fontSize: 18 * scale,
      color: textColor.withAlpha(153),
    );

    // Wait for fonts to be fully loaded
    await GoogleFonts.pendingFonts();

    // ── Paint onto a transparent canvas ──
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, h));

    final maxTextWidth = w * 0.85;

    // 1. Prepare Arabic Painter
    final arPainter = TextPainter(
      text: TextSpan(text: slide.arabicText, style: arStyle),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    );
    arPainter.layout(maxWidth: maxTextWidth);

    // 2. Prepare Translation Painter (if active)
    TextPainter? trPainter;
    if (state.showTranslation && slide.translationText.isNotEmpty) {
      trPainter = TextPainter(
        text: TextSpan(text: slide.translationText, style: trStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      trPainter.layout(maxWidth: maxTextWidth);
    }

    // 3. Prepare Slide Label Painter
    final refPainter = TextPainter(
      text: TextSpan(text: slide.slideLabel, style: refStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    refPainter.layout(maxWidth: maxTextWidth);

    // 4. Calculate Total Block Height
    double totalHeight = arPainter.height;
    if (trPainter != null) {
      totalHeight += 12 * scale + trPainter.height;
    }
    totalHeight += 8 * scale + refPainter.height;

    // 5. Calculate Starting Y matching ReelPreviewCard's Align + Padding behavior
    // ReelPreviewCard has a padding of 20 units inside the Align block.
    final paddingOffset = 40 * scale;
    final activeHeight = totalHeight + paddingOffset;
    final startY = (h - activeHeight) * state.textPosition + (20 * scale);

    // 6. Paint all elements sequentially
    double currentY = startY;

    final arX = (w - arPainter.width) / 2;
    arPainter.paint(canvas, Offset(arX, currentY));
    currentY += arPainter.height;

    if (trPainter != null) {
      currentY += 12 * scale;
      final trX = (w - trPainter.width) / 2;
      trPainter.paint(canvas, Offset(trX, currentY));
      currentY += trPainter.height;
    }

    currentY += 8 * scale;
    final refX = (w - refPainter.width) / 2;
    refPainter.paint(canvas, Offset(refX, currentY));

    // Watermark at top
    if (state.watermarkText.isNotEmpty) {
      final wmStyle = GoogleFonts.outfit(
        fontSize: 18 * scale,
        color: Colors.white.withAlpha(200),
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        shadows: [Shadow(blurRadius: 4 * scale, color: Colors.black54)],
      );

      final wmPainter = TextPainter(
        text: TextSpan(text: state.watermarkText, style: wmStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      wmPainter.layout(maxWidth: maxTextWidth);
      final wmX = (w - wmPainter.width) / 2;
      wmPainter.paint(canvas, Offset(wmX, 30 * scale));
    }

    // ── Save as PNG ──
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    final file = File(outputPath);
    await file.writeAsBytes(byteData!.buffer.asUint8List());

    return outputPath;
  }

  /// Render all slides to PNGs. Returns list of file paths.
  static Future<List<String>> renderAllSlides({
    required ReelState state,
    required int width,
    required int height,
    required String outputDir,
    required void Function(int current, int total) onProgress,
  }) async {
    final paths = <String>[];
    for (int i = 0; i < state.slides.length; i++) {
      onProgress(i, state.slides.length);
      final path = '$outputDir/slide_$i.png';
      await renderSlide(
        slide: state.slides[i],
        state: state,
        width: width,
        height: height,
        outputPath: path,
      );
      paths.add(path);
    }
    return paths;
  }

  static Color _parseColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}

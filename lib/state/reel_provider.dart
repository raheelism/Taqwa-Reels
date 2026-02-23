import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reel_state.dart';
import '../data/models/reel_slide.dart';
import '../data/models/ayah.dart';

// ── Slide splitting logic (max 12 Arabic words per slide) ──

const _kMaxWords = 12;

/// Helper to convert a number to Arabic numerals and wrap it in the ayah end symbol ۝
String _formatAyahNumber(int number) {
  const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  final arabicNumber = number
      .toString()
      .split('')
      .map((d) => digits[int.parse(d)])
      .join('');
  return ' ۝$arabicNumber';
}

List<ReelSlide> buildSlides(
  List<AyahWithTranslation> ayahs,
  String surahName, {
  bool includeBismillah = false,
  bool showAyahNumber = true,
}) {
  final slides = <ReelSlide>[];

  if (includeBismillah) {
    slides.add(
      ReelSlide(
        arabicText: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        translationText:
            'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
        ayahNumber: 0,
        slideLabel: 'Bismillah',
        isPartial: false,
      ),
    );
  }

  for (final ayah in ayahs) {
    var processedAyah = ayah;

    // AlQuran Cloud API prepends Bismillah to Ayah 1 of all surahs except Fatihah (1) and Tawbah (9).
    // We strip it from the Arabic text here so it doesn't merge with the actual Ayah 1.
    if (ayah.surahNumber != 1 &&
        ayah.surahNumber != 9 &&
        ayah.ayahNumber == 1) {
      final arWords = ayah.arabic.trim().split(RegExp(r'\s+'));
      // Bismillah is exactly 4 words: بسم الله الرحمن الرحيم
      if (arWords.length > 4) {
        // Basic check if the first word contains ب, س, م
        if (arWords[0].contains('ب') &&
            arWords[0].contains('س') &&
            arWords[0].contains('م')) {
          processedAyah = AyahWithTranslation(
            surahNumber: ayah.surahNumber,
            ayahNumber: ayah.ayahNumber,
            surahName: ayah.surahName,
            surahEnglishName: ayah.surahEnglishName,
            arabic: arWords.sublist(4).join(' '),
            translation: ayah.translation,
          );
        }
      }
    }

    slides.addAll(_split(processedAyah, surahName, showAyahNumber));
  }

  return slides;
}

List<ReelSlide> _split(
  AyahWithTranslation ayah,
  String surahName,
  bool showAyahNumber,
) {
  final arWords = ayah.arabic.trim().split(RegExp(r'\s+'));
  final trWords = ayah.translation.trim().split(RegExp(r'\s+'));

  if (arWords.length <= _kMaxWords) {
    return [
      ReelSlide(
        arabicText: showAyahNumber
            ? '${ayah.arabic}${_formatAyahNumber(ayah.ayahNumber)}'
            : ayah.arabic,
        translationText: ayah.translation,
        ayahNumber: ayah.ayahNumber,
        slideLabel: '$surahName ${ayah.surahNumber}:${ayah.ayahNumber}',
        isPartial: false,
      ),
    ];
  }

  int parts = (arWords.length / _kMaxWords).ceil();
  final lastPartWords = arWords.length % _kMaxWords;
  final halfLimit = _kMaxWords / 2;

  // If the final remaining segment has fewer words than half the limit, merge it.
  bool mergeLast = false;
  if (parts > 1 && lastPartWords > 0 && lastPartWords <= halfLimit) {
    parts -= 1;
    mergeLast = true;
  }

  return List.generate(parts, (p) {
    final s = p * _kMaxWords;
    final e = (p == parts - 1 && mergeLast)
        ? arWords.length
        : (s + _kMaxWords).clamp(0, arWords.length);

    final ts = ((s / arWords.length) * trWords.length).round().clamp(
      0,
      trWords.length,
    );
    final te = ((e / arWords.length) * trWords.length).round().clamp(
      0,
      trWords.length,
    );

    String arText = arWords.sublist(s, e).join(' ');
    // Only append the ayah number symbol to the very last segment of the ayah
    if (showAyahNumber && p == parts - 1) {
      arText += _formatAyahNumber(ayah.ayahNumber);
    }

    return ReelSlide(
      arabicText: arText,
      translationText: trWords.sublist(ts, te).join(' '),
      ayahNumber: ayah.ayahNumber,
      slideLabel:
          '$surahName ${ayah.surahNumber}:${ayah.ayahNumber} (${p + 1}/$parts)',
      isPartial: true,
    );
  });
}

// ── Notifier ──

class ReelNotifier extends StateNotifier<ReelState> {
  ReelNotifier() : super(ReelState.initial());

  void setSurah(int n, String name) => state = state.copyWith(
    surahNumber: n,
    surahName: name,
    slides: [],
    fromAyah: null,
    toAyah: null,
    currentSlideIndex: 0,
  );

  void setAyahRange(int from, int to, List<ReelSlide> slides) =>
      state = state.copyWith(
        fromAyah: from,
        toAyah: to,
        slides: slides,
        currentSlideIndex: 0,
      );

  void setCurrentSlide(int i) => state = state.copyWith(
    currentSlideIndex: i.clamp(0, state.slides.length - 1),
  );

  void nextSlide() => setCurrentSlide(state.currentSlideIndex + 1);
  void prevSlide() => setCurrentSlide(state.currentSlideIndex - 1);

  void setReciter(r) => state = state.copyWith(reciter: r);
  void setTranslation(t) => state = state.copyWith(translation: t);
  void setBackground(bg) => state = state.copyWith(background: bg);
  void setFont(f) => state = state.copyWith(font: f);
  void setTextColor(c) => state = state.copyWith(textColor: c);
  void setTextPosition(p) => state = state.copyWith(textPosition: p);
  void setFontSize(s) => state = state.copyWith(fontSize: s);
  void setDimOpacity(o) => state = state.copyWith(dimOpacity: o);
  void setShowTranslation(v) => state = state.copyWith(showTranslation: v);
  void setShowShadow(v) => state = state.copyWith(showArabicShadow: v);
  void setIncludeBismillah(v) => state = state.copyWith(includeBismillah: v);
  void setShowAyahNumber(v) => state = state.copyWith(showAyahNumber: v);
  void setWatermarkText(v) => state = state.copyWith(watermarkText: v);
  void setExportOptions(o) => state = state.copyWith(exportOptions: o);
  void reset() => state = ReelState.initial();
}

// ── Providers ──

final reelProvider = StateNotifierProvider<ReelNotifier, ReelState>(
  (_) => ReelNotifier(),
);

final currentSlideProvider = Provider<ReelSlide?>((ref) {
  final s = ref.watch(reelProvider);
  return s.slides.isEmpty ? null : s.slides[s.currentSlideIndex];
});

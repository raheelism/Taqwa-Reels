import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reel_state.dart';
import '../data/models/reel_slide.dart';
import '../data/models/ayah.dart';

// ── Slide splitting logic (max 12 Arabic words per slide) ──

const _kMaxWords = 12;

List<ReelSlide> buildSlides(
  List<AyahWithTranslation> ayahs,
  String surahName,
) =>
    ayahs.expand((a) => _split(a, surahName)).toList();

List<ReelSlide> _split(AyahWithTranslation ayah, String surahName) {
  final arWords = ayah.arabic.trim().split(RegExp(r'\s+'));
  final trWords = ayah.translation.trim().split(RegExp(r'\s+'));

  if (arWords.length <= _kMaxWords) {
    return [
      ReelSlide(
        arabicText: ayah.arabic,
        translationText: ayah.translation,
        ayahNumber: ayah.ayahNumber,
        slideLabel: '$surahName ${ayah.surahNumber}:${ayah.ayahNumber}',
        isPartial: false,
      ),
    ];
  }

  final parts = (arWords.length / _kMaxWords).ceil();
  return List.generate(parts, (p) {
    final s = p * _kMaxWords;
    final e = (s + _kMaxWords).clamp(0, arWords.length);
    final ts =
        ((s / arWords.length) * trWords.length).round().clamp(0, trWords.length);
    final te =
        ((e / arWords.length) * trWords.length).round().clamp(0, trWords.length);
    return ReelSlide(
      arabicText: arWords.sublist(s, e).join(' '),
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

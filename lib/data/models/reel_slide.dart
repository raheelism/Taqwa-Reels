/// A single slide in the reel. Long ayahs are auto-split into multiple slides.
class ReelSlide {
  final String arabicText;
  final String translationText;
  final int ayahNumber;
  final String slideLabel;    // e.g. "Al-Fatiha 1:2" or "Al-Fatiha 1:2 (1/3)"
  final bool isPartial;       // true if this is a split part of a longer ayah

  const ReelSlide({
    required this.arabicText,
    required this.translationText,
    required this.ayahNumber,
    required this.slideLabel,
    required this.isPartial,
  });
}

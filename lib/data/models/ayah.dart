/// Represents a single ayah with both Arabic text and its translation.
class AyahWithTranslation {
  final String arabic;
  final String translation;
  final int surahNumber;
  final int ayahNumber;
  final String surahName;          // Arabic name
  final String surahEnglishName;

  const AyahWithTranslation({
    required this.arabic,
    required this.translation,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.surahEnglishName,
  });
}

/// Represents a single ayah with both Arabic text and its translation.
class AyahWithTranslation {
  final String arabic;
  final String translation;
  final int surahNumber;
  final int ayahNumber;
  final String surahName; // Arabic name
  final String surahEnglishName;

  const AyahWithTranslation({
    required this.arabic,
    required this.translation,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.surahEnglishName,
  });

  Map<String, dynamic> toJson() => {
    'arabic': arabic,
    'translation': translation,
    'surahNumber': surahNumber,
    'ayahNumber': ayahNumber,
    'surahName': surahName,
    'surahEnglishName': surahEnglishName,
  };

  factory AyahWithTranslation.fromJson(Map<String, dynamic> json) {
    return AyahWithTranslation(
      arabic: json['arabic'] as String,
      translation: json['translation'] as String,
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      surahName: json['surahName'] as String,
      surahEnglishName: json['surahEnglishName'] as String,
    );
  }
}

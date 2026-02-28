/// Represents a single Dua (supplication) with Arabic text,
/// transliteration, multiple translations, and source reference.
class Dua {
  final int id;
  final String arabic;
  final String transliteration;
  final Map<String, String> translations; // language code → translation
  final DuaSource source;
  final String reference; // e.g. "Surah Al-Baqarah 2:201" or "Sahih Muslim 2722"
  final String? category; // e.g. "Morning/Evening", "Protection", "Forgiveness"
  final String? occasion; // When to recite this dua
  final List<String> tags;

  const Dua({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translations,
    required this.source,
    required this.reference,
    this.category,
    this.occasion,
    this.tags = const [],
  });

  /// Convenience getter for English translation.
  String get english => translations['en'] ?? '';

  /// Convenience getter for Urdu translation.
  String get urdu => translations['ur'] ?? '';

  /// Convenience getter for French translation.
  String get french => translations['fr'] ?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'arabic': arabic,
    'transliteration': transliteration,
    'translations': translations,
    'source': source.name,
    'reference': reference,
    'category': category,
    'occasion': occasion,
    'tags': tags,
  };

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'] as int,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      translations: Map<String, String>.from(json['translations'] as Map),
      source: DuaSource.values.firstWhere(
        (e) => e.name == json['source'],
      ),
      reference: json['reference'] as String,
      category: json['category'] as String?,
      occasion: json['occasion'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

/// Source of the dua.
enum DuaSource {
  quran,
  hadith,
}

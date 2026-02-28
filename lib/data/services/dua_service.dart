import '../constants/duas.dart';
import '../models/dua.dart';

/// Service for querying and filtering duas.
class DuaService {
  const DuaService._();

  /// All available duas.
  static List<Dua> get all => kDuas;

  /// Total count of duas.
  static int get count => kDuas.length;

  /// Get a dua by its id.
  static Dua? getById(int id) {
    try {
      return kDuas.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get all Quranic duas.
  static List<Dua> get quranicDuas =>
      kDuas.where((d) => d.source == DuaSource.quran).toList();

  /// Get all Hadith duas.
  static List<Dua> get hadithDuas =>
      kDuas.where((d) => d.source == DuaSource.hadith).toList();

  /// Filter duas by category (case-insensitive partial match).
  static List<Dua> byCategory(String category) => kDuas
      .where(
        (d) =>
            d.category?.toLowerCase().contains(category.toLowerCase()) == true,
      )
      .toList();

  /// Filter duas by tag.
  static List<Dua> byTag(String tag) =>
      kDuas.where((d) => d.tags.contains(tag.toLowerCase())).toList();

  /// Search duas by keyword across translations, category, occasion, and tags.
  static List<Dua> search(String query) {
    final q = query.toLowerCase();
    return kDuas.where((d) {
      if (d.arabic.contains(q)) return true;
      if (d.transliteration.toLowerCase().contains(q)) return true;
      for (final t in d.translations.values) {
        if (t.toLowerCase().contains(q)) return true;
      }
      if (d.category?.toLowerCase().contains(q) == true) return true;
      if (d.occasion?.toLowerCase().contains(q) == true) return true;
      if (d.reference.toLowerCase().contains(q)) return true;
      if (d.tags.any((tag) => tag.contains(q))) return true;
      return false;
    }).toList();
  }

  /// Get all unique categories.
  static List<String> get categories => kDuas
      .where((d) => d.category != null)
      .map((d) => d.category!)
      .toSet()
      .toList()
    ..sort();

  /// Get all unique tags.
  static List<String> get tags =>
      kDuas.expand((d) => d.tags).toSet().toList()..sort();

  /// Get a random dua.
  static Dua get random => (kDuas.toList()..shuffle()).first;

  /// Get daily duas (tagged with 'daily').
  static List<Dua> get dailyDuas => byTag('daily');

  /// Get morning adhkar duas.
  static List<Dua> get morningDuas => byTag('morning');

  /// Get evening adhkar duas.
  static List<Dua> get eveningDuas => byTag('evening');

  /// Get duas for protection.
  static List<Dua> get protectionDuas => byTag('protection');

  /// Get duas for forgiveness.
  static List<Dua> get forgivenessDuas => byTag('forgiveness');

  /// Get duas related to parents.
  static List<Dua> get parentsDuas => byTag('parents');

  /// Get duas related to family and children.
  static List<Dua> get familyDuas => byTag('family');

  /// Get duas for sleep / bedtime.
  static List<Dua> get sleepDuas => byTag('sleep');

  /// Get dhikr (remembrance) duas.
  static List<Dua> get dhikrDuas => byTag('dhikr');

  /// Get powerful / highly recommended duas.
  static List<Dua> get powerfulDuas => byTag('powerful');

  /// Get duas for patience and calamity.
  static List<Dua> get calamityDuas => byTag('calamity');
}

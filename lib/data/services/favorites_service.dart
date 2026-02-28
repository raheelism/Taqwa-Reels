import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Manages a local favorites list of ayah selections.
/// Stored as JSON strings in a Hive box keyed by "surah:from-to".
class FavoritesService {
  static const _boxName = 'favorites';

  static Box<String> get _box => Hive.box<String>(_boxName);

  /// Initialize the box — call once at app startup.
  static Future<void> init() async {
    await Hive.openBox<String>(_boxName);
  }

  /// Check if a specific surah+range is favorited.
  static bool isFavorite(int surahNumber, int fromAyah, int toAyah) {
    return _box.containsKey(_key(surahNumber, fromAyah, toAyah));
  }

  /// Toggle favorite status. Returns the new state.
  static bool toggle({
    required int surahNumber,
    required String surahName,
    required int fromAyah,
    required int toAyah,
  }) {
    final key = _key(surahNumber, fromAyah, toAyah);
    if (_box.containsKey(key)) {
      _box.delete(key);
      return false;
    } else {
      _box.put(
        key,
        jsonEncode({
          'surahNumber': surahNumber,
          'surahName': surahName,
          'fromAyah': fromAyah,
          'toAyah': toAyah,
          'savedAt': DateTime.now().toIso8601String(),
        }),
      );
      return true;
    }
  }

  /// Get all favorites as a list of maps, sorted newest first.
  static List<Map<String, dynamic>> getAll() {
    final items = _box.values
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList();
    items.sort((a, b) {
      final aDate = DateTime.tryParse(a['savedAt'] ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b['savedAt'] ?? '') ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
    return items;
  }

  /// Number of favorites saved.
  static int get count => _box.length;

  static String _key(int surah, int from, int to) => '$surah:$from-$to';
}

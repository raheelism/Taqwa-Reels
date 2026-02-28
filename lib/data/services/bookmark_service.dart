import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Tracks per-surah bookmark + progress (which ayah ranges were made into reels).
/// Stored entirely in local Hive — no server needed.
class BookmarkService {
  static const _boxName = 'bookmarks';
  static Box<String>? _box;

  static Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  /// Bookmark or un-bookmark a surah.
  static bool toggleBookmark({
    required int surahNumber,
    required String surahName,
    required int totalAyahs,
  }) {
    final key = _surahKey(surahNumber);
    final existing = _getEntry(surahNumber);

    if (existing != null) {
      // Un-bookmark
      _box?.delete(key);
      return false;
    } else {
      // Bookmark
      _box?.put(
        key,
        jsonEncode({
          'surahNumber': surahNumber,
          'surahName': surahName,
          'totalAyahs': totalAyahs,
          'completedRanges': <List<int>>[],
          'bookmarkedAt': DateTime.now().toIso8601String(),
        }),
      );
      return true;
    }
  }

  /// Check if a surah is bookmarked.
  static bool isBookmarked(int surahNumber) =>
      _box?.containsKey(_surahKey(surahNumber)) ?? false;

  /// Record that an ayah range has been used in a reel.
  /// This is called after a reel is exported.
  static void recordProgress({
    required int surahNumber,
    required String surahName,
    required int totalAyahs,
    required int fromAyah,
    required int toAyah,
  }) {
    final key = _surahKey(surahNumber);
    final existing = _getEntry(surahNumber);

    final List<List<int>> ranges;
    if (existing != null) {
      ranges = (existing['completedRanges'] as List)
          .map((r) => (r as List).cast<int>())
          .toList();
    } else {
      ranges = [];
    }

    // Only add if not already recorded
    final alreadyExists = ranges.any((r) => r[0] == fromAyah && r[1] == toAyah);
    if (!alreadyExists) {
      ranges.add([fromAyah, toAyah]);
    }

    _box?.put(
      key,
      jsonEncode({
        'surahNumber': surahNumber,
        'surahName': surahName,
        'totalAyahs': totalAyahs,
        'completedRanges': ranges,
        'bookmarkedAt':
            existing?['bookmarkedAt'] ?? DateTime.now().toIso8601String(),
      }),
    );
  }

  /// Get the progress fraction (0.0 – 1.0) for a surah.
  static double getProgress(int surahNumber) {
    final entry = _getEntry(surahNumber);
    if (entry == null) return 0.0;

    final totalAyahs = entry['totalAyahs'] as int;
    if (totalAyahs == 0) return 0.0;

    final ranges = (entry['completedRanges'] as List)
        .map((r) => (r as List).cast<int>())
        .toList();

    // Merge overlapping ranges and count unique ayahs covered
    final covered = <int>{};
    for (final r in ranges) {
      for (int i = r[0]; i <= r[1]; i++) {
        covered.add(i);
      }
    }

    return (covered.length / totalAyahs).clamp(0.0, 1.0);
  }

  /// Number of unique ayahs covered for a surah.
  static int getCoveredAyahs(int surahNumber) {
    final entry = _getEntry(surahNumber);
    if (entry == null) return 0;

    final ranges = (entry['completedRanges'] as List)
        .map((r) => (r as List).cast<int>())
        .toList();

    final covered = <int>{};
    for (final r in ranges) {
      for (int i = r[0]; i <= r[1]; i++) {
        covered.add(i);
      }
    }
    return covered.length;
  }

  /// Get all bookmarked surahs sorted by most recent.
  static List<Map<String, dynamic>> getAll() {
    final items = (_box?.values ?? [])
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList();
    items.sort((a, b) {
      final aDate = DateTime.tryParse(a['bookmarkedAt'] ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b['bookmarkedAt'] ?? '') ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
    return items;
  }

  /// Total number of bookmarked surahs.
  static int get count => _box?.length ?? 0;

  // ── Internal ──

  static String _surahKey(int surahNumber) => 'surah_$surahNumber';

  static Map<String, dynamic>? _getEntry(int surahNumber) {
    final json = _box?.get(_surahKey(surahNumber));
    if (json == null) return null;
    return jsonDecode(json) as Map<String, dynamic>;
  }
}

import 'package:hive_flutter/hive_flutter.dart';

/// Tracks user activity, streaks, and stats entirely in local Hive storage.
class StatsService {
  static const _boxName = 'user_stats';
  static Box<dynamic>? _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    _refreshStreak();
  }

  // ── Reels created ──

  static int get totalReelsCreated =>
      _box?.get('totalReels', defaultValue: 0) ?? 0;

  static void incrementReels() {
    _box?.put('totalReels', totalReelsCreated + 1);
    _recordToday();
  }

  // ── Images saved ──

  static int get totalImagesSaved =>
      _box?.get('totalImages', defaultValue: 0) ?? 0;

  static void incrementImages() {
    _box?.put('totalImages', totalImagesSaved + 1);
    _recordToday();
  }

  // ── Shares ──

  static int get totalShares =>
      _box?.get('totalShares', defaultValue: 0) ?? 0;

  static void incrementShares() {
    _box?.put('totalShares', totalShares + 1);
  }

  // ── Total ayahs used ──

  static int get totalAyahsUsed =>
      _box?.get('totalAyahs', defaultValue: 0) ?? 0;

  static void addAyahs(int count) {
    _box?.put('totalAyahs', totalAyahsUsed + count);
  }

  // ── Streak ──

  static int get currentStreak =>
      _box?.get('currentStreak', defaultValue: 0) ?? 0;

  static int get longestStreak =>
      _box?.get('longestStreak', defaultValue: 0) ?? 0;

  /// The date string (yyyy-MM-dd) of the last active day.
  static String get _lastActiveDay =>
      _box?.get('lastActiveDay', defaultValue: '') ?? '';

  /// Days active (total unique days the app was used productively).
  static int get daysActive =>
      _box?.get('daysActive', defaultValue: 0) ?? 0;

  /// First use date for "member since".
  static DateTime get memberSince {
    final iso = _box?.get('memberSince', defaultValue: '') ?? '';
    if (iso.isEmpty) return DateTime.now();
    return DateTime.tryParse(iso) ?? DateTime.now();
  }

  // ── Internal streak logic ──

  static void _recordToday() {
    final today = _todayString();
    if (_lastActiveDay == today) return; // already recorded

    // Set member since on first ever use
    if ((_box?.get('memberSince', defaultValue: '') ?? '').isEmpty) {
      _box?.put('memberSince', DateTime.now().toIso8601String());
    }

    final yesterday = _dateString(DateTime.now().subtract(const Duration(days: 1)));

    if (_lastActiveDay == yesterday) {
      // Consecutive day → extend streak
      final newStreak = currentStreak + 1;
      _box?.put('currentStreak', newStreak);
      if (newStreak > longestStreak) {
        _box?.put('longestStreak', newStreak);
      }
    } else {
      // Streak broken → start fresh
      _box?.put('currentStreak', 1);
      if (longestStreak == 0) _box?.put('longestStreak', 1);
    }

    _box?.put('lastActiveDay', today);
    _box?.put('daysActive', daysActive + 1);
  }

  /// Called on init to zero-out streak if user missed yesterday.
  static void _refreshStreak() {
    final today = _todayString();
    final yesterday = _dateString(DateTime.now().subtract(const Duration(days: 1)));

    if (_lastActiveDay != today && _lastActiveDay != yesterday) {
      _box?.put('currentStreak', 0);
    }
  }

  static String _todayString() => _dateString(DateTime.now());

  static String _dateString(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

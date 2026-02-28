import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/background_item.dart';

/// Persists the most recent 15 background selections.
class RecentBackgroundsService {
  static const _boxName = 'recent_backgrounds';
  static const _maxRecent = 15;

  static Box<String> get _box => Hive.box<String>(_boxName);

  /// Initialize the box — call once at app startup.
  static Future<void> init() async {
    await Hive.openBox<String>(_boxName);
  }

  /// Record a background selection. Moves it to front if already present.
  static void add(BackgroundItem item) {
    final key = _keyFor(item);
    // Remove old entry so it gets pushed to front
    if (_box.containsKey(key)) {
      _box.delete(key);
    }
    // Trim oldest if at limit
    while (_box.length >= _maxRecent) {
      _box.deleteAt(0);
    }
    _box.put(key, jsonEncode(_serialize(item)));
  }

  /// Get all recent backgrounds, newest first.
  static List<BackgroundItem> getAll() {
    return _box.values
        .map((json) {
          try {
            return _deserialize(jsonDecode(json) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<BackgroundItem>()
        .toList()
        .reversed
        .toList();
  }

  static int get count => _box.length;

  static String _keyFor(BackgroundItem item) {
    if (item.type == BackgroundType.solidColor) {
      return 'solid_${item.solidColorHex}';
    }
    return '${item.type.name}_${item.id}';
  }

  static Map<String, dynamic> _serialize(BackgroundItem item) => {
    'id': item.id,
    'type': item.type.name,
    'previewUrl': item.previewUrl,
    'fullUrl': item.fullUrl,
    'duration': item.duration,
    'solidColorHex': item.solidColorHex,
  };

  static BackgroundItem _deserialize(Map<String, dynamic> json) {
    final typeName = json['type'] as String? ?? 'image';
    final type = BackgroundType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => BackgroundType.image,
    );
    return BackgroundItem(
      id: json['id'] as int? ?? 0,
      type: type,
      previewUrl: json['previewUrl'] as String? ?? '',
      fullUrl: json['fullUrl'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      solidColorHex: json['solidColorHex'] as String?,
    );
  }
}

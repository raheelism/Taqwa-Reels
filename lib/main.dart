import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/generated_video.dart';
import 'data/services/favorites_service.dart';
import 'data/services/recent_backgrounds_service.dart';
import 'data/services/stats_service.dart';
import 'data/services/bookmark_service.dart';
import 'data/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(GeneratedVideoAdapter());
  await Hive.openBox<GeneratedVideo>('videos');
  await FavoritesService.init();
  await RecentBackgroundsService.init();
  await StatsService.init();
  await BookmarkService.init();
  await NotificationService.init();

  runApp(const ProviderScope(child: TaqwaReelsApp()));
}

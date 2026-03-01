import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/main_shell.dart';
import 'screens/ayah_selection/ayah_selection_screen.dart';
import 'screens/background/background_screen.dart';
import 'screens/customize/customize_screen.dart';
import 'screens/preview_export/preview_export_screen.dart';
import 'screens/gallery/gallery_screen.dart';
import 'screens/gallery/video_detail_screen.dart';
import 'screens/stats/stats_screen.dart';
import 'screens/bookmarks/bookmarks_screen.dart';
import 'screens/dua/dua_screen.dart';
import 'screens/hadith/hadith_screen.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/home', builder: (_, __) => const MainShell()),
    GoRoute(path: '/stats', builder: (_, __) => const StatsScreen()),
    GoRoute(path: '/bookmarks', builder: (_, __) => const BookmarksScreen()),
    GoRoute(path: '/duas', builder: (_, __) => const DuaScreen()),
    GoRoute(path: '/hadith-reels', builder: (_, __) => const HadithScreen()),
    GoRoute(
      path: '/quran-reels',
      builder: (_, __) => const AyahSelectionScreen(),
    ),
    GoRoute(path: '/background', builder: (_, __) => const BackgroundScreen()),
    GoRoute(path: '/customize', builder: (context, state) => CustomizeScreen()),
    GoRoute(path: '/preview', builder: (_, __) => const PreviewExportScreen()),
    GoRoute(path: '/gallery', builder: (_, __) => const GalleryScreen()),
    GoRoute(
      path: '/video-detail',
      builder: (context, state) {
        final videoId = state.extra as String;
        return VideoDetailScreen(videoId: videoId);
      },
    ),
  ],
);

class TaqwaReelsApp extends StatelessWidget {
  const TaqwaReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Taqwa Feeds',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: _router,
    );
  }
}

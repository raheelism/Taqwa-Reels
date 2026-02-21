import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'screens/ayah_selection/ayah_selection_screen.dart';
import 'screens/background/background_screen.dart';
import 'screens/customize/customize_screen.dart';
import 'screens/preview_export/preview_export_screen.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const AyahSelectionScreen(),
    ),
    GoRoute(
      path: '/background',
      builder: (_, __) => const BackgroundScreen(),
    ),
    GoRoute(
      path: '/customize',
      builder: (_, __) => const CustomizeScreen(),
    ),
    GoRoute(
      path: '/preview',
      builder: (_, __) => const PreviewExportScreen(),
    ),
  ],
);

class TaqwaReelsApp extends StatelessWidget {
  const TaqwaReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TaqwaReels',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: _router,
    );
  }
}

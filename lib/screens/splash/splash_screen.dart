import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/generated_video.dart';
import '../../data/services/favorites_service.dart';
import '../../data/services/recent_backgrounds_service.dart';
import '../../data/services/stats_service.dart';
import '../../data/services/bookmark_service.dart';
import '../../data/services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _entryCtrl;
  late final AnimationController _particleCtrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _shimmerOpacity;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;

  @override
  void initState() {
    super.initState();

    // Entry animation — 2.2s total
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Gentle pulse loop on logo
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Particle rotation loop
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();

    // ── Logo ──
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );

    // ── Expanding ring behind logo ──
    _ringScale = Tween<double>(begin: 0.5, end: 1.8).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );
    _ringOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );

    // ── Title ──
    _titleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.35, 0.60, curve: Curves.easeOutCubic),
      ),
    );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.35, 0.55, curve: Curves.easeOut),
      ),
    );

    // ── Subtitle ──
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.50, 0.70, curve: Curves.easeOut),
      ),
    );

    // ── Bottom shimmer ──
    _shimmerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
      ),
    );

    _entryCtrl.forward();

    // Run init & animation concurrently — navigate when BOTH are done
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // Start service init in parallel with the splash animation
    final initFuture = _initServices();

    // Minimum splash duration so animation completes
    final minSplash = Future.delayed(const Duration(milliseconds: 1500));

    // Wait for whichever takes longer
    await Future.wait([initFuture, minSplash]);

    if (mounted) context.go('/home');
  }

  /// Initialize all app services (runs DURING splash animation)
  static Future<void> _initServices() async {
    await Hive.openBox<GeneratedVideo>('videos');
    await Future.wait([
      FavoritesService.init(),
      RecentBackgroundsService.init(),
      StatsService.init(),
      BookmarkService.init(),
      NotificationService.init(),
    ]);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _pulseCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background gradient ──
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.3),
                radius: 1.2,
                colors: [
                  Color(0xFF1A2040), // subtle lighter center
                  Color(0xFF0A0E1A), // app bg
                  Color(0xFF060810),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // ── Floating particle dots ──
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (context, _) => CustomPaint(
              size: size,
              painter: _ParticlePainter(
                progress: _particleCtrl.value,
                entryProgress: _entryCtrl.value,
              ),
            ),
          ),

          // ── Main content ──
          AnimatedBuilder(
            animation: _entryCtrl,
            builder: (context, _) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Expanding ring
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ring
                        Transform.scale(
                          scale: _ringScale.value,
                          child: Opacity(
                            opacity: _ringOpacity.value,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withAlpha(80),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Logo with pulse
                        AnimatedBuilder(
                          animation: _pulseCtrl,
                          builder: (context, child) {
                            final pulse = 1.0 + (_pulseCtrl.value * 0.04);
                            return Transform.scale(
                              scale: _logoScale.value * pulse,
                              child: Opacity(
                                opacity: _logoOpacity.value,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(60),
                                  blurRadius: 40,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(20),
                                  blurRadius: 80,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/icons/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Title
                    Transform.translate(
                      offset: Offset(0, _titleSlide.value),
                      child: Opacity(
                        opacity: _titleOpacity.value,
                        child: Text(
                          'TaqwaReels',
                          style: GoogleFonts.outfit(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: AppColors.primary.withAlpha(100),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Opacity(
                      opacity: _subtitleOpacity.value,
                      child: Text(
                        'Share the words of Allah ﷻ',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // ── Bottom decoration ──
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _entryCtrl,
              builder: (context, _) {
                return Opacity(
                  opacity: _shimmerOpacity.value,
                  child: Column(
                    children: [
                      // Decorative line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildGradientLine(toRight: false),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.auto_awesome,
                            color: AppColors.primary.withAlpha(140),
                            size: 14,
                          ),
                          const SizedBox(width: 12),
                          _buildGradientLine(toRight: true),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                        style: GoogleFonts.amiri(
                          fontSize: 16,
                          color: AppColors.primary.withAlpha(180),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientLine({required bool toRight}) {
    return Container(
      width: 60,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: toRight
              ? [AppColors.primary.withAlpha(120), Colors.transparent]
              : [Colors.transparent, AppColors.primary.withAlpha(120)],
        ),
      ),
    );
  }
}

// ── Floating particles painter ──

class _ParticlePainter extends CustomPainter {
  final double progress;
  final double entryProgress;

  _ParticlePainter({required this.progress, required this.entryProgress});

  @override
  void paint(Canvas canvas, Size size) {
    if (entryProgress < 0.2) return;

    final opacity = ((entryProgress - 0.2) / 0.3).clamp(0.0, 1.0);
    final rng = Random(42);

    for (int i = 0; i < 18; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final radius = 1.0 + rng.nextDouble() * 2.0;
      final speed = 0.3 + rng.nextDouble() * 0.7;
      final phase = rng.nextDouble() * 2 * pi;

      final x = baseX + sin(progress * 2 * pi * speed + phase) * 20;
      final y = baseY + cos(progress * 2 * pi * speed * 0.7 + phase) * 15;

      final paint = Paint()
        ..color = AppColors.primary.withAlpha((40 * opacity).toInt());

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;
}

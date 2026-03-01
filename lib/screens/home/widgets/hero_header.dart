import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Premium hero header with Taqwa Feeds branding, greeting, and action icons.
class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'Assalamu Alaikum 🌙';
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    if (hour < 21) return 'Good Evening 🌅';
    return 'Assalamu Alaikum 🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF121835), Color(0xFF0F1328), AppColors.bg],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top bar: logo + actions ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.sm,
                0,
              ),
              child: Row(
                children: [
                  // App logo
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.mosque_rounded,
                      color: Color(0xFF0A0E1A),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ).createShader(bounds),
                    child: Text(
                      'Taqwa Feeds',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark_rounded,
                      color: Colors.white54,
                      size: 22,
                    ),
                    tooltip: 'Bookmarks',
                    onPressed: () => context.push('/bookmarks'),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.white54,
                      size: 22,
                    ),
                    tooltip: 'Stats',
                    onPressed: () => context.push('/stats'),
                  ),
                ],
              ),
            ),

            // ── Greeting + Bismillah ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                children: [
                  Text(
                    _greeting,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
                    style: GoogleFonts.amiri(
                      fontSize: 20,
                      color: AppColors.primary.withAlpha(200),
                      height: 1.8,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create beautiful Islamic content',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

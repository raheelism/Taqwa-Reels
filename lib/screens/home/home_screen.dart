import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Hero Header ──
            SliverToBoxAdapter(child: _buildHeroHeader(context)),

            // ── Category Cards ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Text(
                  'Create',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
                delegate: SliverChildListDelegate(_buildCategoryCards(context)),
              ),
            ),

            // ── Templates Section ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Templates',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showComingSoon(context),
                      child: const Text(
                        'See All',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildTemplatesRow(context)),

            // ── Premade Samples Section ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Premade Samples',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showComingSoon(context),
                      child: const Text(
                        'See All',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildSamplesRow(context)),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }

  // ── Hero Header ──

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF121835), AppColors.bg],
        ),
      ),
      child: Column(
        children: [
          // App title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ).createShader(bounds),
            child: Text(
              'TaqwaReels',
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Bismillah
          Text(
            'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
            style: GoogleFonts.amiri(
              fontSize: 22,
              color: AppColors.primary.withAlpha(200),
              height: 1.8,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),

          // Tagline
          Text(
            'Create beautiful Islamic reels in seconds',
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Cards ──

  List<Widget> _buildCategoryCards(BuildContext context) {
    final categories = [
      _CategoryData(
        icon: Icons.menu_book_rounded,
        title: 'Quran Reels',
        subtitle: 'Ayah videos',
        gradient: const [Color(0xFF1A3A5C), Color(0xFF0D253F)],
        isActive: true,
        onTap: () => context.push('/quran-reels'),
      ),
      _CategoryData(
        icon: Icons.auto_stories_rounded,
        title: 'Hadith Reels',
        subtitle: 'Prophet\'s sayings',
        gradient: const [Color(0xFF2D1B4E), Color(0xFF1A0F30)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
      _CategoryData(
        icon: Icons.volunteer_activism_rounded,
        title: 'Dua Reels',
        subtitle: 'Supplications',
        gradient: const [Color(0xFF1B4332), Color(0xFF0B2B20)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
      _CategoryData(
        icon: Icons.brightness_5_rounded,
        title: 'Adkaar Reels',
        subtitle: 'Daily remembrance',
        gradient: const [Color(0xFF4A3000), Color(0xFF2E1D00)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
      _CategoryData(
        icon: Icons.format_quote_rounded,
        title: 'Qools',
        subtitle: 'Sahaba & Scholars',
        gradient: const [Color(0xFF3B1A1A), Color(0xFF250E0E)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
      _CategoryData(
        icon: Icons.add_circle_outline_rounded,
        title: 'More',
        subtitle: 'Coming soon',
        gradient: const [Color(0xFF1A2040), Color(0xFF131832)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
    ];

    return categories.map((c) => _buildCategoryCard(context, c)).toList();
  }

  Widget _buildCategoryCard(BuildContext context, _CategoryData data) {
    return GestureDetector(
      onTap: data.onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: data.gradient,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: data.isActive
              ? Border.all(color: AppColors.primary.withAlpha(100), width: 1.5)
              : null,
        ),
        child: Stack(
          children: [
            // Glow effect for active
            if (data.isActive)
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withAlpha(30),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    data.icon,
                    color: data.isActive
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    size: 28,
                  ),
                  const Spacer(),
                  Text(
                    data.title,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: data.isActive
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.subtitle,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!data.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bgCardLight,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                          ),
                          child: Text(
                            'Soon',
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Templates Row ──

  Widget _buildTemplatesRow(BuildContext context) {
    final templates = [
      _TemplateData('Golden Mosque', Color(0xFFC8A24E), Icons.mosque_rounded),
      _TemplateData(
        'Night Spiritual',
        Color(0xFF4A9EE0),
        Icons.nights_stay_rounded,
      ),
      _TemplateData(
        'Minimal White',
        Color(0xFFE0E0E0),
        Icons.light_mode_rounded,
      ),
      _TemplateData(
        'Emotional Sunset',
        Color(0xFFFF7043),
        Icons.wb_twilight_rounded,
      ),
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: templates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final t = templates[i];
          return GestureDetector(
            onTap: () => _showComingSoon(context),
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: t.color.withAlpha(60), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: t.color.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(t.icon, color: t.color, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.name,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Premade Samples Row ──

  Widget _buildSamplesRow(BuildContext context) {
    final samples = [
      _SampleData('Al-Fatiha', 'Surah 1', Color(0xFF1A3A5C)),
      _SampleData('Ayat ul-Kursi', 'Surah 2:255', Color(0xFF2D1B4E)),
      _SampleData('Al-Mulk', 'Surah 67', Color(0xFF1B4332)),
      _SampleData('Ar-Rahman', 'Surah 55', Color(0xFF4A3000)),
      _SampleData('Ya-Sin', 'Surah 36', Color(0xFF3B1A1A)),
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: samples.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final s = samples[i];
          return GestureDetector(
            onTap: () => _showComingSoon(context),
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [s.color, s.color.withAlpha(60)],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Stack(
                children: [
                  // Play icon
                  Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(80),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white70,
                        size: 28,
                      ),
                    ),
                  ),
                  // Label
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(180),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(AppSpacing.radiusMd),
                          bottomRight: Radius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            s.subtitle,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Coming soon inshaAllah! 🤲',
          style: GoogleFonts.outfit(),
        ),
        backgroundColor: AppColors.bgCardLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ── Data classes ──

class _CategoryData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.isActive,
    required this.onTap,
  });
}

class _TemplateData {
  final String name;
  final Color color;
  final IconData icon;
  const _TemplateData(this.name, this.color, this.icon);
}

class _SampleData {
  final String name;
  final String subtitle;
  final Color color;
  const _SampleData(this.name, this.subtitle, this.color);
}

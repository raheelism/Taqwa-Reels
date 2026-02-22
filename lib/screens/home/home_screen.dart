import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'widgets/hero_header.dart';
import 'widgets/category_card.dart';
import 'widgets/templates_row.dart';
import 'widgets/samples_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Hero
            const SliverToBoxAdapter(child: HeroHeader()),

            // Section: Create
            SliverToBoxAdapter(child: _sectionTitle(context, 'Create')),
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

            // Section: Templates
            SliverToBoxAdapter(
              child: _sectionTitleWithAction(context, 'Templates'),
            ),
            SliverToBoxAdapter(
              child: TemplatesRow(onTap: () => _showComingSoon(context)),
            ),

            // Section: Premade Samples
            SliverToBoxAdapter(
              child: _sectionTitleWithAction(context, 'Premade Samples'),
            ),
            SliverToBoxAdapter(
              child: SamplesRow(onTap: () => _showComingSoon(context)),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _sectionTitleWithAction(BuildContext context, String title) {
    return Padding(
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
            title,
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
    );
  }

  List<Widget> _buildCategoryCards(BuildContext context) {
    final cards = [
      CategoryCardData(
        icon: Icons.menu_book_rounded,
        title: 'Quran Reels',
        subtitle: 'Ayah videos',
        gradient: const [Color(0xFF1A3A5C), Color(0xFF0D253F)],
        isActive: true,
        onTap: () => context.push('/quran-reels'),
      ),
      CategoryCardData(
        icon: Icons.auto_stories_rounded,
        title: 'Hadith Reels',
        subtitle: "Prophet's sayings",
        gradient: const [Color(0xFF2D1B4E), Color(0xFF1A0F30)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
      CategoryCardData(
        icon: Icons.volunteer_activism_rounded,
        title: 'Dua Reels',
        subtitle: 'Supplications',
        gradient: const [Color(0xFF1B4332), Color(0xFF0B2B20)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
      CategoryCardData(
        icon: Icons.brightness_5_rounded,
        title: 'Adkaar Reels',
        subtitle: 'Daily remembrance',
        gradient: const [Color(0xFF4A3000), Color(0xFF2E1D00)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
      CategoryCardData(
        icon: Icons.format_quote_rounded,
        title: 'Qools',
        subtitle: 'Sahaba & Scholars',
        gradient: const [Color(0xFF3B1A1A), Color(0xFF250E0E)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
      CategoryCardData(
        icon: Icons.add_circle_outline_rounded,
        title: 'More',
        subtitle: 'Coming soon',
        gradient: const [Color(0xFF1A2040), Color(0xFF131832)],
        isActive: false,
        onTap: () => _showComingSoon(context),
      ),
    ];
    return cards.map((c) => CategoryCard(data: c)).toList();
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

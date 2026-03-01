import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/background_item.dart';
import '../../data/services/quran_api_service.dart';
import '../../state/reel_provider.dart';
import 'widgets/hero_header.dart';
import 'widgets/category_card.dart';
import 'widgets/surah_of_the_day.dart';
import 'widgets/templates_row.dart';
import 'widgets/samples_row.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _loadingSurahOfDay = false;

  Future<void> _onSurahOfDayTapped(Map<String, dynamic> surah) async {
    if (_loadingSurahOfDay) return;
    setState(() => _loadingSurahOfDay = true);

    try {
      final notifier = ref.read(reelProvider.notifier);
      final surahNumber = surah['number'] as int;
      final surahName = surah['name'] as String;
      final totalAyahs = surah['ayahs'] as int;

      notifier.setSurah(surahNumber, surahName);

      final to = totalAyahs > 3 ? 3 : totalAyahs;
      final state = ref.read(reelProvider);

      final ayahs = await ref
          .read(quranApiProvider)
          .fetchRange(surahNumber, 1, to, state.translation.edition);

      final slides = buildSlides(
        ayahs,
        surahName,
        includeBismillah: state.includeBismillah,
        showAyahNumber: state.showAyahNumber,
      );

      notifier.setAyahRange(1, to, slides);
      notifier.setBackground(BackgroundItem.solidColor('#0A0E1A'));

      if (!mounted) return;
      context.push('/customize');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not load surah. Check your connection.',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: AppColors.bgCardLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingSurahOfDay = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Hero
            const SliverToBoxAdapter(child: HeroHeader()),

            // Surah of the Day
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.md,
                  bottom: AppSpacing.sm,
                ),
                child: _loadingSurahOfDay
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : SurahOfTheDay(onTap: _onSurahOfDayTapped),
              ),
            ),

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
        isActive: true,
        onTap: () => context.push('/hadith-reels'),
      ),
      CategoryCardData(
        icon: Icons.volunteer_activism_rounded,
        title: 'Dua Reels',
        subtitle: 'Supplications',
        gradient: const [Color(0xFF1B4332), Color(0xFF0B2B20)],
        isActive: true,
        onTap: () => context.push('/duas'),
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

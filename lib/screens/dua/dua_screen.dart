import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/dua.dart';
import '../../data/models/reel_slide.dart';
import '../../data/models/background_item.dart';
import '../../data/services/dua_service.dart';
import '../../state/reel_provider.dart';
import 'widgets/dua_detail_sheet.dart';

// ── Helper: Convert a Dua into ReelSlide(s) ──

const _kMaxArabicWords = 12;

/// Splits a [Dua] into one or more [ReelSlide]s.
/// Short duas become one slide; long ones are auto-split (max 12 Arabic words per slide).
List<ReelSlide> duaToSlides(Dua dua) {
  final arWords = dua.arabic.trim().split(RegExp(r'\s+'));
  final trWords = dua.english.trim().split(RegExp(r'\s+'));
  final label = dua.reference;

  if (arWords.length <= _kMaxArabicWords) {
    return [
      ReelSlide(
        arabicText: dua.arabic,
        translationText: dua.english,
        ayahNumber: dua.id,
        slideLabel: label,
        isPartial: false,
      ),
    ];
  }

  // Split into multiple slides
  int parts = (arWords.length / _kMaxArabicWords).ceil();
  final lastPartWords = arWords.length % _kMaxArabicWords;
  final halfLimit = _kMaxArabicWords / 2;

  bool mergeLast = false;
  if (parts > 1 && lastPartWords > 0 && lastPartWords <= halfLimit) {
    parts -= 1;
    mergeLast = true;
  }

  return List.generate(parts, (p) {
    final s = p * _kMaxArabicWords;
    final e = (p == parts - 1 && mergeLast)
        ? arWords.length
        : (s + _kMaxArabicWords).clamp(0, arWords.length);

    final ts = ((s / arWords.length) * trWords.length).round().clamp(0, trWords.length);
    final te = ((e / arWords.length) * trWords.length).round().clamp(0, trWords.length);

    return ReelSlide(
      arabicText: arWords.sublist(s, e).join(' '),
      translationText: trWords.sublist(ts, te).join(' '),
      ayahNumber: dua.id,
      slideLabel: parts > 1 ? '$label (${p + 1}/$parts)' : label,
      isPartial: parts > 1,
    );
  });
}

class DuaScreen extends ConsumerStatefulWidget {
  const DuaScreen({super.key});

  @override
  ConsumerState<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends ConsumerState<DuaScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  // Category chips with icons
  static const _categoryChips = <({String label, IconData icon})>[
    (label: 'All', icon: Icons.apps_rounded),
    (label: 'Guidance', icon: Icons.explore_rounded),
    (label: 'Protection', icon: Icons.shield_rounded),
    (label: 'Forgiveness', icon: Icons.favorite_rounded),
    (label: 'Morning/Evening', icon: Icons.wb_sunny_rounded),
    (label: 'Patience', icon: Icons.self_improvement_rounded),
    (label: 'Gratitude', icon: Icons.volunteer_activism_rounded),
    (label: 'Provision', icon: Icons.trending_up_rounded),
    (label: 'Knowledge', icon: Icons.school_rounded),
    (label: 'Family', icon: Icons.family_restroom_rounded),
    (label: 'Travel', icon: Icons.flight_takeoff_rounded),
    (label: 'Health', icon: Icons.healing_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Dua> _getFilteredDuas() {
    List<Dua> duas;

    // Tab filter
    switch (_tabCtrl.index) {
      case 1:
        duas = DuaService.quranicDuas;
        break;
      case 2:
        duas = DuaService.hadithDuas;
        break;
      default:
        duas = DuaService.all;
    }

    // Category filter
    if (_selectedCategory != null && _selectedCategory != 'All') {
      duas = duas
          .where((d) =>
              d.category?.toLowerCase().contains(_selectedCategory!.toLowerCase()) == true ||
              d.tags.any((t) => t.toLowerCase().contains(_selectedCategory!.toLowerCase())))
          .toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      duas = duas.where((d) {
        if (d.arabic.contains(q)) return true;
        if (d.transliteration.toLowerCase().contains(q)) return true;
        for (final t in d.translations.values) {
          if (t.toLowerCase().contains(q)) return true;
        }
        if (d.reference.toLowerCase().contains(q)) return true;
        if (d.category?.toLowerCase().contains(q) == true) return true;
        return false;
      }).toList();
    }

    return duas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            _buildTabs(),
            _buildCategoryChips(),
            Expanded(child: _buildDuaList()),
          ],
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.md, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 4),
          Text(
            'Duas',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryDim,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${DuaService.count} duas',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.outfit(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search duas...',
          hintStyle: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.bgCard,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ── Tabs: All / Quran / Hadith ──
  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TabBar(
          controller: _tabCtrl,
          onTap: (_) => setState(() {}),
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerHeight: 0,
          labelColor: AppColors.bg,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Quran'),
            Tab(text: 'Hadith'),
          ],
        ),
      ),
    );
  }

  // ── Category chips ──
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
        scrollDirection: Axis.horizontal,
        itemCount: _categoryChips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final chip = _categoryChips[i];
          final selected = (_selectedCategory == null && chip.label == 'All') ||
              _selectedCategory == chip.label;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedCategory = chip.label == 'All' ? null : chip.label;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary.withAlpha(30) : AppColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    chip.icon,
                    size: 14,
                    color: selected ? AppColors.primary : AppColors.textMuted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    chip.label,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
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

  // ── Dua list ──
  Widget _buildDuaList() {
    final duas = _getFilteredDuas();

    if (duas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted.withAlpha(80)),
            const SizedBox(height: 12),
            Text(
              'No duas found',
              style: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xxl),
      itemCount: duas.length,
      itemBuilder: (context, i) => _DuaCard(
        dua: duas[i],
        index: i,
        onTap: () => _openDetail(duas[i]),
        onCreateReel: () => _createReel(duas[i]),
      ),
    );
  }

  void _openDetail(Dua dua) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DuaDetailSheet(
        dua: dua,
        onCreateReel: () => _createReel(dua),
      ),
    );
  }

  /// Converts a [Dua] into ReelSlides and navigates to the background picker.
  void _createReel(Dua dua) {
    // Close any open bottom sheet
    Navigator.of(context).popUntil((route) => route.settings.name == '/duas' || route.isFirst);

    final slides = duaToSlides(dua);
    final notifier = ref.read(reelProvider.notifier);
    notifier.reset();
    notifier.setSurah(0, 'Dua');
    notifier.setAyahRange(1, slides.length, slides);
    notifier.setBackground(BackgroundItem.solidColor('#0A0E1A'));

    context.push('/background');
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  DUA CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _DuaCard extends StatelessWidget {
  final Dua dua;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onCreateReel;

  const _DuaCard({required this.dua, required this.index, required this.onTap, required this.onCreateReel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: number + source badge + reference
                Row(
                  children: [
                    // Number circle
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withAlpha(25),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${dua.id}',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Source badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: dua.source == DuaSource.quran
                            ? const Color(0xFF1A3A5C)
                            : const Color(0xFF2D1B4E),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        dua.source == DuaSource.quran ? '📖 Quran' : '📜 Hadith',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: dua.source == DuaSource.quran
                              ? const Color(0xFF4A9EE0)
                              : const Color(0xFFB388FF),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Create reel button
                    GestureDetector(
                      onTap: onCreateReel,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.videocam_rounded, size: 13, color: AppColors.primary),
                            const SizedBox(width: 3),
                            Text(
                              'Reel',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Copy button
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                          text: '${dua.arabic}\n\n${dua.transliteration}\n\n${dua.english}\n\n— ${dua.reference}',
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dua copied!', style: GoogleFonts.outfit()),
                            backgroundColor: AppColors.bgCardLight,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Icon(Icons.copy_rounded, size: 16, color: AppColors.textMuted),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Arabic text
                Text(
                  dua.arabic,
                  style: GoogleFonts.amiri(
                    fontSize: 18,
                    height: 2.0,
                    color: AppColors.primary,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),

                const SizedBox(height: 8),

                // English translation (truncated)
                Text(
                  dua.english,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                // Reference + category
                Row(
                  children: [
                    Icon(
                      dua.source == DuaSource.quran
                          ? Icons.menu_book_rounded
                          : Icons.auto_stories_rounded,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        dua.reference,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (dua.category != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.bgCardLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          dua.category!,
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

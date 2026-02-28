import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/constants/backgrounds.dart';
import '../../data/models/background_item.dart';
import '../../data/services/pixabay_service.dart';
import '../../data/services/recent_backgrounds_service.dart';
import '../../state/reel_provider.dart';
import '../shared/step_indicator.dart';
import 'widgets/background_grid_item.dart';
import 'widgets/category_chips.dart';

class BackgroundScreen extends ConsumerStatefulWidget {
  const BackgroundScreen({super.key});

  @override
  ConsumerState<BackgroundScreen> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends ConsumerState<BackgroundScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final _imgScroll = ScrollController();
  final _vidScroll = ScrollController();

  String _selectedCategory = kBackgroundCategories.first;
  List<BackgroundItem> _images = [];
  List<BackgroundItem> _videos = [];
  bool _loadingImages = true;
  bool _loadingVideos = true;
  int _imgPage = 1;
  int _vidPage = 1;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() {
      if (mounted) setState(() {});
    });
    _imgScroll.addListener(_onImageScroll);
    _vidScroll.addListener(_onVideoScroll);
    _loadImages();
    _loadVideos();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _imgScroll.dispose();
    _vidScroll.dispose();
    super.dispose();
  }

  // ── Infinite scroll ──

  void _onImageScroll() {
    if (_imgScroll.position.pixels >=
        _imgScroll.position.maxScrollExtent - 200) {
      _loadImages(append: true);
    }
  }

  void _onVideoScroll() {
    if (_vidScroll.position.pixels >=
        _vidScroll.position.maxScrollExtent - 200) {
      _loadVideos(append: true);
    }
  }

  // ── Data ──

  Future<void> _loadImages({bool append = false}) async {
    if (append && !_loadingImages) {
      _imgPage++;
    }
    setState(() => _loadingImages = true);
    try {
      final items = await PixabayService().searchImages(
        _selectedCategory,
        page: _imgPage,
      );
      if (!mounted) return;
      setState(() {
        _images = append ? [..._images, ...items] : items;
        _loadingImages = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingImages = false);
    }
  }

  Future<void> _loadVideos({bool append = false}) async {
    if (append && !_loadingVideos) {
      _vidPage++;
    }
    setState(() => _loadingVideos = true);
    try {
      final items = await PixabayService().searchVideos(
        _selectedCategory,
        page: _vidPage,
      );
      if (!mounted) return;
      setState(() {
        _videos = append ? [..._videos, ...items] : items;
        _loadingVideos = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingVideos = false);
    }
  }

  void _onCategoryChanged(String cat) {
    setState(() {
      _selectedCategory = cat;
      _imgPage = 1;
      _vidPage = 1;
      _images = [];
      _videos = [];
    });
    _loadImages();
    _loadVideos();
  }

  void _selectBackground(BackgroundItem item) {
    ref.read(reelProvider.notifier).setBackground(item);
    RecentBackgroundsService.add(item);
    setState(() {});
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final selectedBg = ref.watch(reelProvider).background;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Background'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: StepIndicator(current: 2),
            ),

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: TabBar(
                  controller: _tabCtrl,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.bg,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Solid Color'),
                    Tab(text: 'Images'),
                    Tab(text: 'Videos'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Recent backgrounds
            if (RecentBackgroundsService.count > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'Recent',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 56,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      itemCount: RecentBackgroundsService.getAll().length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final item = RecentBackgroundsService.getAll()[i];
                        final isSelected = selectedBg?.id == item.id &&
                            selectedBg?.type == item.type;
                        return GestureDetector(
                          onTap: () => _selectBackground(item),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white.withAlpha(30),
                                width: isSelected ? 2 : 1,
                              ),
                              color: item.type == BackgroundType.solidColor
                                  ? Color(int.parse(
                                      (item.solidColorHex ?? '#0A0E1A')
                                          .replaceFirst('#', '0xFF')))
                                  : AppColors.bgCard,
                              image: item.type != BackgroundType.solidColor &&
                                      item.previewUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(item.previewUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, color: AppColors.primary, size: 18)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),

            // Category chips — hidden on solid color tab
            if (_tabCtrl.index != 0) ...[
              CategoryChips(
                categories: kBackgroundCategories,
                selected: _selectedCategory,
                onChanged: _onCategoryChanged,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            // Grid
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _buildSolidColorGrid(selectedBg),
                  _buildGrid(
                    _images,
                    _loadingImages,
                    _imgScroll,
                    selectedBg,
                    isVideo: false,
                  ),
                  _buildGrid(
                    _videos,
                    _loadingVideos,
                    _vidScroll,
                    selectedBg,
                    isVideo: true,
                  ),
                ],
              ),
            ),

            // Next
            if (selectedBg != null)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/customize'),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Next: Customize Style'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(
    List<BackgroundItem> items,
    bool loading,
    ScrollController scroll,
    BackgroundItem? selectedBg, {
    required bool isVideo,
  }) {
    if (loading && items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    return GridView.builder(
      controller: scroll,
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 9 / 16,
      ),
      itemCount: items.length + (loading ? 1 : 0),
      itemBuilder: (_, i) {
        if (i >= items.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          );
        }
        final item = items[i];
        return BackgroundGridItem(
          item: item,
          isSelected: selectedBg?.id == item.id,
          isVideo: isVideo,
          onTap: () => _selectBackground(item),
        );
      },
    );
  }

  // ── Preset solid colors ──
  static const _solidColorPresets = <String>[
    '#0A0E1A', // Dark Navy
    '#1A2040', // Night Blue
    '#0D253F', // Deep Ocean
    '#1B4332', // Forest Green
    '#2D1B4E', // Royal Purple
    '#3B1A1A', // Dark Burgundy
    '#4A3000', // Dark Amber
    '#1A3A5C', // Steel Blue
    '#0F172A', // Slate
    '#18181B', // Charcoal
    '#1C1917', // Warm Black
    '#000000', // Pure Black
    '#0C4A6E', // Ocean Blue
    '#134E4A', // Teal
    '#3F3F46', // Zinc
    '#292524', // Stone
  ];

  Widget _buildSolidColorGrid(BackgroundItem? selectedBg) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: _solidColorPresets.length,
      itemBuilder: (_, i) {
        final hex = _solidColorPresets[i];
        final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
        final isSelected = selectedBg?.type == BackgroundType.solidColor &&
            selectedBg?.solidColorHex == hex;

        return GestureDetector(
          onTap: () => _selectBackground(BackgroundItem.solidColor(hex)),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.white.withAlpha(30),
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}

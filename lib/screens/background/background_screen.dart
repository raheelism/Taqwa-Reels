import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/constants/backgrounds.dart';
import '../../data/models/background_item.dart';
import '../../data/services/pixabay_service.dart';
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
    _tabCtrl = TabController(length: 2, vsync: this);
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
                    Tab(text: 'Images'),
                    Tab(text: 'Videos'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Category chips
            CategoryChips(
              categories: kBackgroundCategories,
              selected: _selectedCategory,
              onChanged: _onCategoryChanged,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Grid
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
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
}

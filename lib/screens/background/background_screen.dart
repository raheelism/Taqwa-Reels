import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/constants/backgrounds.dart';
import '../../data/models/background_item.dart';
import '../../data/services/pixabay_service.dart';
import '../../state/reel_provider.dart';

class BackgroundScreen extends ConsumerStatefulWidget {
  const BackgroundScreen({super.key});

  @override
  ConsumerState<BackgroundScreen> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends ConsumerState<BackgroundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String _selectedCategory = kBackgroundCategories.first;

  // Image state
  List<BackgroundItem> _images = [];
  bool _loadingImages = false;
  int _imagePage = 1;

  // Video state
  List<BackgroundItem> _videos = [];
  bool _loadingVideos = false;
  int _videoPage = 1;

  final _imageScrollCtrl = ScrollController();
  final _videoScrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) setState(() {});
    });
    _imageScrollCtrl.addListener(_onImageScroll);
    _videoScrollCtrl.addListener(_onVideoScroll);
    _loadImages();
    _loadVideos();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _imageScrollCtrl.dispose();
    _videoScrollCtrl.dispose();
    super.dispose();
  }

  void _onImageScroll() {
    if (_imageScrollCtrl.position.pixels >=
            _imageScrollCtrl.position.maxScrollExtent - 200 &&
        !_loadingImages) {
      _imagePage++;
      _loadImages(append: true);
    }
  }

  void _onVideoScroll() {
    if (_videoScrollCtrl.position.pixels >=
            _videoScrollCtrl.position.maxScrollExtent - 200 &&
        !_loadingVideos) {
      _videoPage++;
      _loadVideos(append: true);
    }
  }

  Future<void> _loadImages({bool append = false}) async {
    setState(() => _loadingImages = true);
    try {
      final items = await ref
          .read(pixabayProvider)
          .searchImages(_selectedCategory, page: _imagePage);
      if (!mounted) return;
      setState(() {
        if (append) {
          _images.addAll(items);
        } else {
          _images = items;
        }
        _loadingImages = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingImages = false);
    }
  }

  Future<void> _loadVideos({bool append = false}) async {
    setState(() => _loadingVideos = true);
    try {
      final items = await ref
          .read(pixabayProvider)
          .searchVideos(_selectedCategory, page: _videoPage);
      if (!mounted) return;
      setState(() {
        if (append) {
          _videos.addAll(items);
        } else {
          _videos = items;
        }
        _loadingVideos = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingVideos = false);
    }
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _imagePage = 1;
      _videoPage = 1;
      _images = [];
      _videos = [];
    });
    _loadImages();
    _loadVideos();
  }

  void _selectBackground(BackgroundItem item) {
    ref.read(reelProvider.notifier).setBackground(item);
    setState(() {}); // refresh selection highlight
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reelProvider);
    final selectedBg = state.background;

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
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: _buildStepIndicator(2),
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
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: kBackgroundCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = kBackgroundCategories[i];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => _onCategoryChanged(cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.bgCardLight,
                        ),
                      ),
                      child: Text(
                        cat[0].toUpperCase() + cat.substring(1),
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.bg
                              : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Grid
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _buildImageGrid(selectedBg),
                  _buildVideoGrid(selectedBg),
                ],
              ),
            ),

            // Next button
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

  Widget _buildImageGrid(BackgroundItem? selectedBg) {
    if (_images.isEmpty && _loadingImages) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_images.isEmpty) {
      return Center(
        child: Text(
          'No images found',
          style: GoogleFonts.outfit(color: AppColors.textMuted),
        ),
      );
    }

    return GridView.builder(
      controller: _imageScrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemCount: _images.length + (_loadingImages ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= _images.length) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final item = _images[i];
        final isSelected = selectedBg?.id == item.id;
        return _buildGridItem(item, isSelected);
      },
    );
  }

  Widget _buildVideoGrid(BackgroundItem? selectedBg) {
    if (_videos.isEmpty && _loadingVideos) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_videos.isEmpty) {
      return Center(
        child: Text(
          'No videos found',
          style: GoogleFonts.outfit(color: AppColors.textMuted),
        ),
      );
    }

    return GridView.builder(
      controller: _videoScrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemCount: _videos.length + (_loadingVideos ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= _videos.length) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final item = _videos[i];
        final isSelected = selectedBg?.id == item.id;
        return _buildGridItem(item, isSelected, isVideo: true);
      },
    );
  }

  Widget _buildGridItem(
    BackgroundItem item,
    bool isSelected, {
    bool isVideo = false,
  }) {
    return GestureDetector(
      onTap: () => _selectBackground(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: isSelected ? 2.5 : 0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            isSelected ? AppSpacing.radiusMd - 1 : AppSpacing.radiusMd,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: item.previewUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.bgCard,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.bgCard,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.textMuted,
                  ),
                ),
              ),

              // Video badge
              if (isVideo)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.videocam_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Video',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),

              // Selection checkmark
              if (isSelected)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.bg,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final isActive = i < current;
        final isCurrent = i == current - 1;
        return Row(
          children: [
            Container(
              width: isCurrent ? 28 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            if (i < 3) const SizedBox(width: 6),
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/background_item.dart';

/// A grid tile showing a background image/video thumbnail with selection state.
class BackgroundGridItem extends StatelessWidget {
  final BackgroundItem item;
  final bool isSelected;
  final bool isVideo;
  final VoidCallback onTap;

  const BackgroundGridItem({
    super.key,
    required this.item,
    required this.isSelected,
    this.isVideo = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
}

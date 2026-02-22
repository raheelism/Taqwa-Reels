import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Grid data for a category card.
class CategoryCardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryCardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.isActive,
    required this.onTap,
  });
}

/// A single category card tile for the home grid.
class CategoryCard extends StatelessWidget {
  final CategoryCardData data;
  const CategoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
}

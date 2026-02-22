import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Horizontal scrolling row of template preview cards.
class TemplatesRow extends StatelessWidget {
  final VoidCallback onTap;
  const TemplatesRow({super.key, required this.onTap});

  static const _templates = [
    _TemplateData('Golden Mosque', Color(0xFFC8A24E), Icons.mosque_rounded),
    _TemplateData(
      'Night Spiritual',
      Color(0xFF4A9EE0),
      Icons.nights_stay_rounded,
    ),
    _TemplateData('Minimal White', Color(0xFFE0E0E0), Icons.light_mode_rounded),
    _TemplateData(
      'Emotional Sunset',
      Color(0xFFFF7043),
      Icons.wb_twilight_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _templates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final t = _templates[i];
          return GestureDetector(
            onTap: onTap,
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
}

class _TemplateData {
  final String name;
  final Color color;
  final IconData icon;
  const _TemplateData(this.name, this.color, this.icon);
}

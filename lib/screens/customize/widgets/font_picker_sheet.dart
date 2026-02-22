import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/constants/font_options.dart';
import '../../../state/reel_provider.dart';

/// Bottom sheet to pick a font family for Arabic text.
void showFontPicker(BuildContext context, WidgetRef ref) {
  final state = ref.read(reelProvider);
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.bgCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.bgCardLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Choose Font',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...kFontOptions.map((f) {
              final isSelected = state.font.id == f.id;
              return ListTile(
                title: Text(
                  f.displayName,
                  style: TextStyle(
                    fontFamily: f.googleFontFamily,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  'بِسْمِ ٱللَّهِ',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.getFont(
                    f.googleFontFamily,
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(reelProvider.notifier).setFont(f);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      );
    },
  );
}

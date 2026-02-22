import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/constants/translations.dart';
import '../../../data/models/translation_edition.dart';

/// Translation edition selector list.
class TranslationSelector extends StatelessWidget {
  final TranslationEdition selected;
  final ValueChanged<TranslationEdition> onChanged;

  const TranslationSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: kTranslations.map((t) {
          final isSelected = selected.id == t.id;
          return ListTile(
            dense: true,
            selected: isSelected,
            selectedTileColor: AppColors.primaryDim,
            leading: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 20,
            ),
            title: Text(
              t.displayName,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              t.language,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            onTap: () => onChanged(t),
          );
        }).toList(),
      ),
    );
  }
}

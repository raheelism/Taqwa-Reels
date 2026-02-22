import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

import '../../../data/constants/reciters.dart';
import '../../../data/models/reciter.dart';

/// Horizontal scrolling reciter choice chips.
class ReciterChips extends StatelessWidget {
  final Reciter selected;
  final ValueChanged<Reciter> onChanged;

  const ReciterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: kReciters.map((r) {
          final isSelected = selected.id == r.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(r.name),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.bgCard,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.bg : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.bgCardLight,
              ),
              onSelected: (_) => onChanged(r),
            ),
          );
        }).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/surah.dart';

/// Searchable surah list with number badges and Arabic names.
class SurahListPanel extends StatelessWidget {
  final List<Surah> surahs;
  final bool loading;
  final String? error;
  final Surah? selected;
  final VoidCallback onRetry;
  final ValueChanged<Surah> onSelect;
  final double height;

  const SurahListPanel({
    super.key,
    required this.surahs,
    required this.loading,
    required this.error,
    required this.selected,
    required this.onRetry,
    required this.onSelect,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: height,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (error != null) {
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: AppColors.textMuted, size: 40),
              const SizedBox(height: 8),
              Text(
                error!,
                style: const TextStyle(color: AppColors.error),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: surahs.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: AppColors.bgCardLight),
          itemBuilder: (_, i) => _buildTile(surahs[i]),
        ),
      ),
    );
  }

  Widget _buildTile(Surah surah) {
    final isSelected = selected?.number == surah.number;
    return ListTile(
      dense: true,
      selected: isSelected,
      selectedTileColor: AppColors.primaryDim,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${surah.number}',
            style: TextStyle(
              color: isSelected ? AppColors.bg : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      title: Text(
        surah.englishName,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${surah.numberOfAyahs} ayahs',
        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
      ),
      trailing: Text(
        surah.name,
        style: GoogleFonts.amiri(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontSize: 15,
        ),
        textDirection: TextDirection.rtl,
      ),
      onTap: () => onSelect(surah),
    );
  }
}

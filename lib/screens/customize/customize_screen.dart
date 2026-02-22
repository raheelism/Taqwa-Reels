import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/constants/backgrounds.dart';
import '../../data/constants/font_options.dart';
import '../../state/reel_provider.dart';
import '../shared/reel_preview_card.dart';

class CustomizeScreen extends ConsumerWidget {
  const CustomizeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reelProvider);
    final notifier = ref.read(reelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Style'),
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
              child: _buildStepIndicator(3),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Live Preview ──
                    Center(
                      child: SizedBox(
                        height: 340,
                        child: const ReelPreviewCard(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Font Picker ──
                    _buildControlCard(
                      icon: Icons.font_download_rounded,
                      title: 'Font Family',
                      trailing: Text(
                        state.font.displayName,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () => _showFontPicker(context, ref),
                    ),

                    // ── Font Size Slider ──
                    _buildSliderCard(
                      icon: Icons.format_size_rounded,
                      title: 'Font Size',
                      value: state.fontSize,
                      min: 16,
                      max: 52,
                      label: '${state.fontSize.round()}',
                      onChanged: (v) => notifier.setFontSize(v),
                    ),

                    // ── Dim Opacity Slider ──
                    _buildSliderCard(
                      icon: Icons.brightness_4_rounded,
                      title: 'Background Dimming',
                      value: state.dimOpacity,
                      min: 0.0,
                      max: 0.9,
                      label: '${(state.dimOpacity * 100).round()}%',
                      onChanged: (v) => notifier.setDimOpacity(v),
                    ),

                    // ── Text Position ──
                    _buildSectionLabel('Text Position'),
                    const SizedBox(height: 6),
                    SegmentedButton<double>(
                      segments: const [
                        ButtonSegment(
                          value: 0.15,
                          label: Text('Top'),
                          icon: Icon(Icons.vertical_align_top, size: 18),
                        ),
                        ButtonSegment(
                          value: 0.5,
                          label: Text('Center'),
                          icon: Icon(Icons.vertical_align_center, size: 18),
                        ),
                        ButtonSegment(
                          value: 0.85,
                          label: Text('Bottom'),
                          icon: Icon(Icons.vertical_align_bottom, size: 18),
                        ),
                      ],
                      selected: {state.textPosition},
                      onSelectionChanged: (v) =>
                          notifier.setTextPosition(v.first),
                      style: SegmentedButton.styleFrom(
                        backgroundColor: AppColors.bgCard,
                        selectedBackgroundColor: AppColors.primary,
                        selectedForegroundColor: AppColors.bg,
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Text Color ──
                    _buildSectionLabel('Text Color'),
                    const SizedBox(height: 8),
                    _buildColorSwatches(state.textColor, notifier),
                    const SizedBox(height: AppSpacing.md),

                    // ── Toggles ──
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text(
                              'Show Translation',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: const Text(
                              'Display English translation',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            value: state.showTranslation,
                            activeTrackColor: AppColors.primary,
                            onChanged: (v) => notifier.setShowTranslation(v),
                          ),
                          const Divider(
                            height: 1,
                            color: AppColors.bgCardLight,
                          ),
                          SwitchListTile(
                            title: const Text(
                              'Text Shadow',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: const Text(
                              'Add shadow behind Arabic text',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            value: state.showArabicShadow,
                            activeTrackColor: AppColors.primary,
                            onChanged: (v) => notifier.setShowShadow(v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // ── Next button ──
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/preview'),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Next: Preview & Export'),
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

  // ── Helper Widgets ──

  Widget _buildSectionLabel(String text) => Text(
    text,
    style: GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
  );

  Widget _buildControlCard({
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        tileColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            trailing,
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSliderCard({
    required IconData icon,
    required String title,
    required double value,
    required double min,
    required double max,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 4),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgCardLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.bgCardLight,
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primaryDim,
                trackHeight: 3,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSwatches(String currentHex, ReelNotifier notifier) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: kTextColorPresets.map((hex) {
        final color = hexToColor(hex);
        final isSelected = hex == currentHex;
        return GestureDetector(
          onTap: () => notifier.setTextColor(hex),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(100),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    size: 18,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  void _showFontPicker(BuildContext context, WidgetRef ref) {
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
                  // Show sample Arabic text
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

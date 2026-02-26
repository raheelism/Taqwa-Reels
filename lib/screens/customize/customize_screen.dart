import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../state/reel_provider.dart';
import '../shared/reel_preview_card.dart';
import '../shared/step_indicator.dart';
import 'widgets/color_swatches.dart';
import 'widgets/font_picker_sheet.dart';
import 'widgets/style_controls.dart';

class CustomizeScreen extends ConsumerWidget {
  CustomizeScreen({super.key});

  final _watermarkController = TextEditingController();

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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: StepIndicator(current: 3),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Live Preview
                    const Center(
                      child: SizedBox(height: 340, child: ReelPreviewCard()),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Watermark Input
                    _label('Watermark Text'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _watermarkController
                        ..text = state.watermarkText,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.bgCardLight,
                        hintText: 'e.g. @YourPageName',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (v) => notifier.setWatermarkText(v),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Font Picker
                    ControlCard(
                      icon: Icons.font_download_rounded,
                      title: 'Font Family',
                      trailing: Text(
                        state.font.displayName,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () => showFontPicker(context, ref),
                    ),

                    // Font Size
                    SliderCard(
                      icon: Icons.format_size_rounded,
                      title: 'Font Size',
                      value: state.fontSize,
                      min: 16,
                      max: 52,
                      label: '${state.fontSize.round()}',
                      onChanged: (v) => notifier.setFontSize(v),
                    ),

                    // Dim Opacity
                    SliderCard(
                      icon: Icons.brightness_4_rounded,
                      title: 'Background Dimming',
                      value: state.dimOpacity,
                      min: 0.0,
                      max: 0.9,
                      label: '${(state.dimOpacity * 100).round()}%',
                      onChanged: (v) => notifier.setDimOpacity(v),
                    ),

                    // Text Position
                    _label('Text Position'),
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

                    // Text Color
                    _label('Text Color'),
                    const SizedBox(height: 8),
                    ColorSwatches(
                      currentHex: state.textColor,
                      onChanged: (hex) => notifier.setTextColor(hex),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Toggles
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
                              'Display translation',
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

            // Next
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

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
  );
}

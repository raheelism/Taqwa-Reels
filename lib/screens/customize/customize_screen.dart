import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../state/reel_provider.dart';
import '../shared/reel_preview_card.dart';
import '../shared/step_indicator.dart';
import '../../data/models/export_options.dart';
import 'widgets/aspect_ratio_sheet.dart';
import 'widgets/color_swatches.dart';
import 'widgets/font_picker_sheet.dart';
import 'widgets/style_controls.dart';
import '../../data/constants/style_presets.dart';
import '../../data/constants/font_options.dart';

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

            // ── Pinned compact preview ──
            Container(
              width: double.infinity,
              color: AppColors.bg,
              padding: const EdgeInsets.only(
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                bottom: AppSpacing.sm,
              ),
              child: SizedBox(
                height: 280,
                child: const Center(child: ReelPreviewCard()),
              ),
            ),

            // Thin divider between preview and controls
            const Divider(height: 1, color: AppColors.bgCardLight),

            // ── Scrollable controls panel ──
            Expanded(
              child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Style Presets ──
                    _sectionHeader('Quick Presets'),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: kStylePresets.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final preset = kStylePresets[i];
                          final presetColor = Color(
                            int.parse(preset.textColor.replaceFirst('#', '0xFF')),
                          );
                          final fontOption = kFontOptions.firstWhere(
                            (f) => f.id == preset.fontId,
                            orElse: () => kFontOptions.first,
                          );
                          final isActive = state.textColor == preset.textColor &&
                              state.font.id == preset.fontId;
                          return GestureDetector(
                            onTap: () {
                              notifier.setFont(fontOption);
                              notifier.setTextColor(preset.textColor);
                              notifier.setDimOpacity(preset.dimOpacity);
                              notifier.setFontSize(preset.fontSize);
                              notifier.setShowShadow(preset.showArabicShadow);
                              notifier.setTextPosition(preset.textPosition);
                              notifier.setExportOptions(
                                state.exportOptions.copyWith(
                                  backgroundBlur: preset.backgroundBlur,
                                  translationFontScale: preset.translationFontScale,
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isActive
                                      ? presetColor
                                      : presetColor.withAlpha(40),
                                  width: isActive ? 2 : 1,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    presetColor.withAlpha(18),
                                    AppColors.bgCard,
                                    AppColors.bgCard,
                                  ],
                                ),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: presetColor.withAlpha(50),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Stack(
                                children: [
                                  // Dim overlay preview
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        color: Colors.black.withAlpha(
                                          (preset.dimOpacity * 80).toInt(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Content
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Sample Arabic text preview
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              'بِسْمِ ٱللَّهِ',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.getFont(
                                                fontOption.googleFontFamily,
                                                fontSize: 18,
                                                color: presetColor,
                                                height: 1.4,
                                                shadows: preset
                                                        .showArabicShadow
                                                    ? [
                                                        Shadow(
                                                          color: Colors.black
                                                              .withAlpha(140),
                                                          blurRadius: 6,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Preset name badge
                                        Container(
                                          width: double.infinity,
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                presetColor.withAlpha(25),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            preset.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: presetColor
                                                  .withAlpha(220),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.3,
                                            ),
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Active check badge
                                  if (isActive)
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: presetColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: presetColor
                                                  .withAlpha(100),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Text & Style Section ──
                    _sectionHeader('Text & Style'),
                    const SizedBox(height: AppSpacing.sm),

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

                    // Translation Font Size
                    SliderCard(
                      icon: Icons.translate_rounded,
                      title: 'Translation Size',
                      value: state.exportOptions.translationFontScale,
                      min: 0.3,
                      max: 0.8,
                      label:
                          '${(state.exportOptions.translationFontScale * 100).round()}%',
                      onChanged: (v) => notifier.setExportOptions(
                        state.exportOptions
                            .copyWith(translationFontScale: v),
                      ),
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

                    // ── Watermark Section ──
                    _sectionHeader('Watermark'),
                    const SizedBox(height: AppSpacing.sm),

                    // Watermark Input
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
                    const SizedBox(height: AppSpacing.sm),

                    // Watermark Font Size
                    SliderCard(
                      icon: Icons.format_size_rounded,
                      title: 'Watermark Size',
                      value: state.exportOptions.watermarkFontSize,
                      min: 10,
                      max: 28,
                      label: '${state.exportOptions.watermarkFontSize.round()}',
                      onChanged: (v) => notifier.setExportOptions(
                        state.exportOptions.copyWith(watermarkFontSize: v),
                      ),
                    ),

                    // Watermark Opacity
                    SliderCard(
                      icon: Icons.opacity_rounded,
                      title: 'Watermark Opacity',
                      value: state.exportOptions.watermarkOpacity,
                      min: 0.3,
                      max: 1.0,
                      label: '${(state.exportOptions.watermarkOpacity * 100).round()}%',
                      onChanged: (v) => notifier.setExportOptions(
                        state.exportOptions.copyWith(watermarkOpacity: v),
                      ),
                    ),

                    // Watermark Position
                    _label('Position'),
                    const SizedBox(height: 6),
                    SegmentedButton<WatermarkPosition>(
                      segments: const [
                        ButtonSegment(
                          value: WatermarkPosition.topCenter,
                          label: Text('Top'),
                          icon: Icon(Icons.vertical_align_top, size: 18),
                        ),
                        ButtonSegment(
                          value: WatermarkPosition.bottomCenter,
                          label: Text('Bottom'),
                          icon: Icon(
                              Icons.vertical_align_bottom, size: 18),
                        ),
                        ButtonSegment(
                          value: WatermarkPosition.hidden,
                          label: Text('Hidden'),
                          icon: Icon(
                              Icons.visibility_off_rounded, size: 18),
                        ),
                      ],
                      selected: {state.exportOptions.watermarkPosition},
                      onSelectionChanged: (v) =>
                          notifier.setExportOptions(
                        state.exportOptions
                            .copyWith(watermarkPosition: v.first),
                      ),
                      style: SegmentedButton.styleFrom(
                        backgroundColor: AppColors.bgCard,
                        selectedBackgroundColor: AppColors.primary,
                        selectedForegroundColor: AppColors.bg,
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Background Section ──
                    _sectionHeader('Background'),
                    const SizedBox(height: AppSpacing.sm),

                    // Dim Opacity
                    SliderCard(
                      icon: Icons.brightness_4_rounded,
                      title: 'Dimming',
                      value: state.dimOpacity,
                      min: 0.0,
                      max: 0.9,
                      label: '${(state.dimOpacity * 100).round()}%',
                      onChanged: (v) => notifier.setDimOpacity(v),
                    ),

                    // Background Blur
                    SliderCard(
                      icon: Icons.blur_on_rounded,
                      title: 'Blur',
                      value: state.exportOptions.backgroundBlur,
                      min: 0,
                      max: 20,
                      label: state.exportOptions.backgroundBlur.round() == 0
                          ? 'Off'
                          : '${state.exportOptions.backgroundBlur.round()}px',
                      onChanged: (v) => notifier.setExportOptions(
                        state.exportOptions.copyWith(backgroundBlur: v),
                      ),
                    ),

                    // Background Slow-Mo
                    SliderCard(
                      icon: Icons.slow_motion_video_rounded,
                      title: 'Speed',
                      value: state.exportOptions.bgSlowMo,
                      min: 0.25,
                      max: 1.0,
                      label:
                          '${(state.exportOptions.bgSlowMo * 100).round()}%',
                      onChanged: (v) => notifier.setExportOptions(
                        state.exportOptions.copyWith(
                            bgSlowMo: double.parse(
                                v.toStringAsFixed(2))),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Export Settings Section ──
                    _sectionHeader('Export Settings'),
                    const SizedBox(height: AppSpacing.sm),

                    // Aspect Ratio / Dimensions
                    ControlCard(
                      icon: Icons.aspect_ratio_rounded,
                      title: 'Dimensions',
                      trailing: Text(
                        state.exportOptions.exportRatio.label,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () => showAspectRatioSheet(context, ref),
                    ),

                    // Video Quality
                    _label('Video Quality'),
                    const SizedBox(height: 6),
                    SegmentedButton<VideoQuality>(
                      segments: const [
                        ButtonSegment(
                          value: VideoQuality.low,
                          label: Text('Low'),
                          icon: Icon(Icons.speed_rounded, size: 18),
                        ),
                        ButtonSegment(
                          value: VideoQuality.medium,
                          label: Text('Medium'),
                          icon: Icon(Icons.hd_rounded, size: 18),
                        ),
                        ButtonSegment(
                          value: VideoQuality.high,
                          label: Text('High'),
                          icon: Icon(Icons.high_quality_rounded, size: 18),
                        ),
                      ],
                      selected: {state.exportOptions.videoQuality},
                      onSelectionChanged: (v) =>
                          notifier.setExportOptions(
                        state.exportOptions
                            .copyWith(videoQuality: v.first),
                      ),
                      style: SegmentedButton.styleFrom(
                        backgroundColor: AppColors.bgCard,
                        selectedBackgroundColor: AppColors.primary,
                        selectedForegroundColor: AppColors.bg,
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Intro Padding
                    SliderCard(
                      icon: Icons.timer_rounded,
                      title: 'Intro Silence',
                      value: state.exportOptions.introPadding,
                      min: 0.0,
                      max: 3.0,
                      label: state.exportOptions.introPadding == 0
                          ? 'Off'
                          : '${state.exportOptions.introPadding.toStringAsFixed(1)}s',
                      onChanged: (v) => notifier.setExportOptions(
                        state.exportOptions.copyWith(
                            introPadding: double.parse(
                                v.toStringAsFixed(1))),
                      ),
                    ),

                    // Outro Padding
                    SliderCard(
                      icon: Icons.timer_off_rounded,
                      title: 'Outro Silence',
                      value: state.exportOptions.outroPadding,
                      min: 0.0,
                      max: 3.0,
                      label: state.exportOptions.outroPadding == 0
                          ? 'Off'
                          : '${state.exportOptions.outroPadding.toStringAsFixed(1)}s',
                      onChanged: (v) => notifier.setExportOptions(
                        state.exportOptions.copyWith(
                            outroPadding: double.parse(
                                v.toStringAsFixed(1))),
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

  Widget _sectionHeader(String title) => Row(
    children: [
      Container(
        width: 3,
        height: 18,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    ],
  );
}

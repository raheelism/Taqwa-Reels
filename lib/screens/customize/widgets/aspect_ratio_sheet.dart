import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/export_options.dart';
import '../../../state/reel_provider.dart';

/// Opens the aspect-ratio / dimensions bottom sheet.
void showAspectRatioSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _AspectRatioSheet(ref: ref),
  );
}

class _AspectRatioSheet extends StatefulWidget {
  final WidgetRef ref;
  const _AspectRatioSheet({required this.ref});

  @override
  State<_AspectRatioSheet> createState() => _AspectRatioSheetState();
}

class _AspectRatioSheetState extends State<_AspectRatioSheet> {
  late ExportRatio _selected;
  late TextEditingController _widthCtrl;
  late TextEditingController _heightCtrl;
  String? _widthError;
  String? _heightError;

  static const int _minDim = 300;
  static const int _maxDim = 3840;

  @override
  void initState() {
    super.initState();
    final opts = widget.ref.read(reelProvider).exportOptions;
    _selected = opts.exportRatio;
    _widthCtrl = TextEditingController(
      text: (opts.customWidth ?? 1080).toString(),
    );
    _heightCtrl = TextEditingController(
      text: (opts.customHeight ?? 1920).toString(),
    );
  }

  @override
  void dispose() {
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    if (_selected == ExportRatio.custom) {
      final w = int.tryParse(_widthCtrl.text);
      final h = int.tryParse(_heightCtrl.text);
      bool hasError = false;

      if (w == null || w < _minDim || w > _maxDim) {
        setState(() => _widthError = '$_minDim–$_maxDim px');
        hasError = true;
      } else {
        setState(() => _widthError = null);
      }
      if (h == null || h < _minDim || h > _maxDim) {
        setState(() => _heightError = '$_minDim–$_maxDim px');
        hasError = true;
      } else {
        setState(() => _heightError = null);
      }
      if (hasError) return;
    }

    final notifier = widget.ref.read(reelProvider.notifier);
    final current = widget.ref.read(reelProvider).exportOptions;

    notifier.setExportOptions(
      current.copyWith(
        exportRatio: _selected,
        customWidth:
            _selected == ExportRatio.custom
                ? int.parse(_widthCtrl.text)
                : null,
        customHeight:
            _selected == ExportRatio.custom
                ? int.parse(_heightCtrl.text)
                : null,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text(
              'Aspect Ratio / Dimensions',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Ratio cards
            ..._buildRatioCards(),

            // Custom dimension fields
            if (_selected == ExportRatio.custom) ...[
              const SizedBox(height: AppSpacing.md),
              _buildCustomFields(),
            ],

            const SizedBox(height: AppSpacing.lg),

            // Apply button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRatioCards() {
    return ExportRatio.values.map((ratio) {
      final isActive = _selected == ratio;
      // Compute preview dimensions for ratio
      final previewLabel = ratio == ExportRatio.custom
          ? 'W × H'
          : '${_previewOpts(ratio).width} × ${_previewOpts(ratio).height}';

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: () => setState(() => _selected = ratio),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryDim : AppColors.bgCard,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  ratio.icon,
                  color: isActive ? AppColors.primary : AppColors.textMuted,
                  size: 24,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ratio.label,
                        style: TextStyle(
                          color: isActive
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        previewLabel,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Ratio preview thumbnail
                _buildMiniPreview(ratio, isActive),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  /// Tiny aspect-ratio rectangle preview.
  Widget _buildMiniPreview(ExportRatio ratio, bool isActive) {
    double w, h;
    switch (ratio) {
      case ExportRatio.instagramReel:
        w = 18;
        h = 32;
        break;
      case ExportRatio.instagramPost:
        w = 22;
        h = 27.5;
        break;
      case ExportRatio.instagramSquare:
        w = 28;
        h = 28;
        break;
      case ExportRatio.youtubeVideo:
        w = 36;
        h = 20;
        break;
      case ExportRatio.custom:
        w = 24;
        h = 24;
        break;
    }
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withAlpha(60)
            : AppColors.bgCardLight,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.textMuted,
          width: 1,
        ),
      ),
    );
  }

  Widget _buildCustomFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _widthCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Width (px)',
              labelStyle: const TextStyle(color: AppColors.textMuted),
              errorText: _widthError,
              filled: true,
              fillColor: AppColors.bgCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        const Text('×', style: TextStyle(color: AppColors.textMuted, fontSize: 20)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: TextField(
            controller: _heightCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Height (px)',
              labelStyle: const TextStyle(color: AppColors.textMuted),
              errorText: _heightError,
              filled: true,
              fillColor: AppColors.bgCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper to get preview dimensions for a predefined ratio.
  ExportOptions _previewOpts(ExportRatio ratio) =>
      ExportOptions(exportRatio: ratio);
}

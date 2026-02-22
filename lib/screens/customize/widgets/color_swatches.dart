import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/constants/backgrounds.dart';

/// Circular color swatch picker.
class ColorSwatches extends StatelessWidget {
  final String currentHex;
  final ValueChanged<String> onChanged;

  const ColorSwatches({
    super.key,
    required this.currentHex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: kTextColorPresets.map((hex) {
        final color = hexToColor(hex);
        final isSelected = hex == currentHex;
        return GestureDetector(
          onTap: () => onChanged(hex),
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
}

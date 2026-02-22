import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A 4-dot step progress indicator used at the top of each creation screen.
/// Pass [current] as 1–4 to highlight that step.
class StepIndicator extends StatelessWidget {
  final int current;
  const StepIndicator({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
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

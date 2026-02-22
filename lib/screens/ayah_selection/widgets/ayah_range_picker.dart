import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Ayah From/To range picker with ± increment/decrement buttons.
class AyahRangePicker extends StatelessWidget {
  final TextEditingController fromCtrl;
  final TextEditingController toCtrl;
  final VoidCallback onDecrementFrom;
  final VoidCallback onIncrementFrom;
  final VoidCallback onDecrementTo;
  final VoidCallback onIncrementTo;

  const AyahRangePicker({
    super.key,
    required this.fromCtrl,
    required this.toCtrl,
    required this.onDecrementFrom,
    required this.onIncrementFrom,
    required this.onDecrementTo,
    required this.onIncrementTo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NumberField(
            label: 'From',
            controller: fromCtrl,
            onMinus: onDecrementFrom,
            onPlus: onIncrementFrom,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '—',
            style: TextStyle(color: AppColors.textMuted, fontSize: 20),
          ),
        ),
        Expanded(
          child: _NumberField(
            label: 'To',
            controller: toCtrl,
            onMinus: onDecrementTo,
            onPlus: onIncrementTo,
          ),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _NumberField({
    required this.label,
    required this.controller,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          _RoundButton(icon: Icons.remove, onTap: onMinus),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          _RoundButton(icon: Icons.add, onTap: onPlus),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 18),
      ),
    );
  }
}

// lib/presentation/widgets/car_stat_bar.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CarStatBar extends StatelessWidget {
  final String label;
  final int value; // 0–100

  const CarStatBar({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final ratio = value / 100.0;
    final color = ratio > 0.75
        ? AppTheme.success
        : ratio > 0.45
            ? AppTheme.accentGold
            : AppTheme.accent;

    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(label, style: AppTheme.labelS.copyWith(fontSize: 9)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 28,
          child: Text(
            '$value',
            style: AppTheme.labelS.copyWith(color: AppTheme.textPrimary),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// C:\Users\th366\Desktop\sevakai\frontend\lib\ui\components\summary_card.dart
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';

/// Compact bordered card for secondary operational metrics.
class SummaryCard extends StatelessWidget {
  /// Creates a summary card.
  const SummaryCard({
    required this.label,
    required this.value,
    this.valueColor,
    this.trailing,
    this.padding,
    super.key,
  });

  /// Metric label.
  final String label;

  /// Metric value.
  final String value;

  /// Optional custom value color.
  final Color? valueColor;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Optional padding override.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.neutral500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  value,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: valueColor ?? AppColors.neutral800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\presentation\widgets\stats_card.dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../ui/themes/app_colors.dart';
import '../../../../ui/themes/app_spacing.dart';
import '../../../../ui/themes/app_text_styles.dart';

/// Large, interactive summary card for primary dashboard metrics.
class StatsCard extends StatefulWidget {
  /// Creates a stats card.
  const StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.subtitle,
    this.onTap,
    this.isLoading = false,
    this.badge,
    super.key,
  });

  /// Short uppercase label.
  final String title;

  /// Primary numeric value.
  final String value;

  /// Optional supporting subtitle.
  final String? subtitle;

  /// Icon displayed in the card corner.
  final IconData icon;

  /// Foreground icon color.
  final Color iconColor;

  /// Icon container background color.
  final Color iconBackground;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Whether to show loading placeholders.
  final bool isLoading;

  /// Optional badge text.
  final String? badge;

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  Timer? _pulseTimer;
  bool _visible = true;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant StatsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = Semantics(
      label: '${widget.title}: ${widget.value}',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: widget.isLoading ? _buildLoadingState() : _buildLoadedState(),
      ),
    );

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: _hovered && widget.onTap != null ? 0.92 : 1,
        child: widget.onTap == null
            ? content
            : InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: content,
              ),
      ),
    );
  }

  Widget _buildLoadedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.title,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.neutral500,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (widget.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.dangerRed,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  widget.badge!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                ) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  widget.value,
                  key: ValueKey<String>(widget.value),
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.neutral800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.iconBackground,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              alignment: Alignment.center,
              child: Icon(
                widget.icon,
                color: widget.iconColor,
                size: 20,
              ),
            ),
          ],
        ),
        if (widget.subtitle != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.subtitle!,
            style: AppTextStyles.bodySmall.copyWith(
              color: widget.subtitle!.contains('↑')
                  ? AppColors.successGreen
                  : widget.subtitle!.contains('↓')
                      ? AppColors.dangerRed
                      : AppColors.neutral500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingState() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _visible ? 0.8 : 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 96,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: 120,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 160,
            height: 13,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ],
      ),
    );
  }

  void _syncPulse() {
    _pulseTimer?.cancel();
    if (!widget.isLoading) {
      return;
    }
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (mounted) {
        setState(() => _visible = !_visible);
      }
    });
  }
}

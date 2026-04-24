// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\presentation\widgets\top_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/authentication/domain/entities/auth_user.dart';
import '../../../../features/authentication/domain/entities/user_role.dart';
import '../../../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../sync/models/sync_state.dart';
import '../../../../sync/sync_bloc.dart';
import '../../../../ui/themes/app_colors.dart';
import '../../../../ui/themes/app_spacing.dart';
import '../../../../ui/themes/app_text_styles.dart';

/// Persistent top header for the coordinator dashboard shell.
class TopHeader extends StatelessWidget {
  /// Creates the top header.
  const TopHeader({
    required this.title,
    required this.user,
    required this.activeIncidentCount,
    required this.isRefreshing,
    this.onMenuPressed,
    super.key,
  });

  /// Current page title.
  final String title;

  /// Current authenticated user.
  final AuthUser user;

  /// Number of active incidents.
  final int activeIncidentCount;

  /// Whether the dashboard is currently refreshing.
  final bool isRefreshing;

  /// Optional tablet menu callback.
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.headerBackground,
        border: Border(bottom: BorderSide(color: AppColors.headerBorder)),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: <Widget>[
                  if (onMenuPressed != null)
                    IconButton(
                      onPressed: onMenuPressed,
                      icon: const Icon(Icons.menu_rounded),
                    ),
                  Text(
                    title,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.neutral800,
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<SyncBloc, SyncState>(
                    builder: (BuildContext context, SyncState state) {
                      final (_SyncIndicatorStatus status, Color color) indicator =
                          switch (state.status) {
                        SyncStatus.offline => (_SyncIndicatorStatus.offline, AppColors.dangerRed),
                        SyncStatus.syncing => (_SyncIndicatorStatus.polling, AppColors.warningAmber),
                        _ => (_SyncIndicatorStatus.live, AppColors.successGreen),
                      };
                      return _StatusPill(
                        color: indicator.$2,
                        label: indicator.$1.label,
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.md),
                  if (activeIncidentCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.dangerRedLight,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.circle_rounded,
                            size: 10,
                            color: AppColors.dangerRed,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '$activeIncidentCount Active Incidents',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.dangerRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: AppSpacing.md),
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      const Icon(Icons.notifications_rounded, color: AppColors.neutral500),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.dangerRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(user.name),
                            Text(
                              '${user.role.displayName} - ${user.zoneId}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                    ],
                    onSelected: (String value) {
                      if (value == 'logout') {
                        context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: AppColors.primaryBlue,
                          child: Text(
                            user.initials,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              user.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.neutral800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              user.role.displayName,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isRefreshing)
            const LinearProgressIndicator(
              minHeight: 2,
              color: AppColors.primaryBlue,
              backgroundColor: AppColors.primaryBlueLight,
            ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.circle_rounded, size: 10, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

enum _SyncIndicatorStatus {
  live('Live'),
  polling('Polling'),
  offline('Offline');

  const _SyncIndicatorStatus(this.label);

  final String label;
}

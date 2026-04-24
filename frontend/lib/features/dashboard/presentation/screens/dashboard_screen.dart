// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\presentation\screens\dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../features/authentication/domain/entities/auth_user.dart';
import '../../../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../sync/sync_bloc.dart';
import '../../../../ui/components/summary_card.dart';
import '../../../../ui/themes/app_colors.dart';
import '../../../../ui/themes/app_spacing.dart';
import '../../../../ui/widgets/responsive_layout.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/need_summary.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/needs_data_table.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/stats_card.dart';
import '../widgets/top_header.dart';

/// Root coordinator dashboard screen for SevakAI web administration.
class DashboardScreen extends StatelessWidget {
  /// Creates the dashboard screen.
  const DashboardScreen({
    required this.user,
    super.key,
  });

  /// Current authenticated user.
  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _MobileDashboard(user: user),
      tablet: _TabletDashboard(user: user),
      desktop: _DesktopDashboard(user: user),
    );
  }
}

class _DesktopDashboard extends StatelessWidget {
  const _DesktopDashboard({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return _DashboardScaffold(
      user: user,
      showSidebar: true,
      tabletSidebar: false,
    );
  }
}

class _TabletDashboard extends StatelessWidget {
  const _TabletDashboard({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return _DashboardScaffold(
      user: user,
      showSidebar: true,
      tabletSidebar: true,
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  const _MobileDashboard({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return _DashboardScaffold(
      user: user,
      showSidebar: false,
      tabletSidebar: false,
    );
  }
}

class _DashboardScaffold extends StatelessWidget {
  const _DashboardScaffold({
    required this.user,
    required this.showSidebar,
    required this.tabletSidebar,
  });

  final AuthUser user;
  final bool showSidebar;
  final bool tabletSidebar;

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.path;
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthBloc>.value(value: context.read<AuthBloc>()),
        BlocProvider<SyncBloc>(
          create: (_) => getIt<SyncBloc>()..add(const SyncEvent.started()),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => getIt<DashboardBloc>()
            ..add(DashboardEvent.initialized(zoneId: user.zoneId)),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        bottomNavigationBar: showSidebar
            ? null
            : BottomNavigationBar(
                currentIndex: 0,
                onTap: (int index) {
                  const List<String> routes = <String>[
                    '/coordinator/dashboard',
                    '/coordinator/needs',
                    '/coordinator/volunteers',
                    '/coordinator/resources',
                  ];
                  context.go(routes[index]);
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_rounded),
                    label: 'Overview',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.warning_amber_rounded),
                    label: 'Needs',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_rounded),
                    label: 'Volunteers',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.inventory_2_rounded),
                    label: 'Resources',
                  ),
                ],
              ),
        body: Row(
          children: <Widget>[
            if (showSidebar)
              SidebarNavigation(
                user: user,
                currentRoute: currentRoute,
                isTablet: tabletSidebar,
              ),
            Expanded(
              child: Column(
                children: <Widget>[
                  BlocBuilder<DashboardBloc, DashboardState>(
                    buildWhen: (DashboardState previous, DashboardState current) {
                      final bool previousRefreshing = previous.maybeWhen(
                        loaded: (_, __, ___, ____, _____, bool isRefreshing, ______) => isRefreshing,
                        orElse: () => false,
                      );
                      final bool currentRefreshing = current.maybeWhen(
                        loaded: (_, __, ___, ____, _____, bool isRefreshing, ______) => isRefreshing,
                        orElse: () => false,
                      );
                      return previous.runtimeType != current.runtimeType ||
                          previousRefreshing != currentRefreshing;
                    },
                    builder: (BuildContext context, DashboardState state) {
                      final DashboardStats? staleStats = state.maybeWhen(
                        loaded: (DashboardStats stats, _, __, ___, ____, _____, ______) => stats,
                        error: (_, DashboardStats? lastKnownStats) => lastKnownStats,
                        orElse: () => null,
                      );
                      final bool refreshing = state.maybeWhen(
                        loaded: (_, __, ___, ____, _____, bool isRefreshing, ______) => isRefreshing,
                        orElse: () => false,
                      );
                      return TopHeader(
                        title: 'Dashboard Overview',
                        user: user,
                        activeIncidentCount: staleStats?.activeIncidents ?? 0,
                        isRefreshing: refreshing,
                        onMenuPressed: tabletSidebar ? () {} : null,
                      );
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<DashboardBloc, DashboardState>(
                      builder: (BuildContext context, DashboardState state) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (state is DashboardError &&
                                  state.lastKnownStats != null)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                                  decoration: BoxDecoration(
                                    color: AppColors.dangerRedLight,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    border: Border.all(color: AppColors.dangerRed),
                                  ),
                                  child: Text(
                                    'Showing data from ${state.lastKnownStats!.lastUpdatedAt.toLocal()} ago - reconnecting...',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.dangerRed,
                                        ),
                                  ),
                                ),
                              if (state is DashboardLoading)
                                _buildStatsRow(null, isLoading: true)
                              else if (state is DashboardLoaded)
                                _buildStatsRow(state.stats)
                              else if (state is DashboardError &&
                                  state.lastKnownStats != null)
                                _buildStatsRow(state.lastKnownStats!)
                              else
                                const SizedBox.shrink(),
                              const SizedBox(height: AppSpacing.lg),
                              if (state is DashboardLoaded)
                                Column(
                                  children: <Widget>[
                                    NeedsDataTable(
                                      needs: state.needs,
                                      statusFilter: state.statusFilter,
                                      priorityFilter: state.priorityFilter,
                                      isLoading: false,
                                    ),
                                    const SizedBox(height: AppSpacing.lg),
                                    Wrap(
                                      spacing: AppSpacing.md,
                                      runSpacing: AppSpacing.md,
                                      children: <Widget>[
                                        SummaryCard(
                                          label: 'Volunteer Utilization',
                                          value:
                                              '${state.stats.volunteerUtilizationRate.toStringAsFixed(0)}%',
                                          valueColor: state.stats.hasCriticalSituation
                                              ? AppColors.dangerRed
                                              : AppColors.neutral800,
                                        ),
                                        SummaryCard(
                                          label: 'Resource Allocation',
                                          value:
                                              '${state.stats.resourceAllocationRate.toStringAsFixed(0)}%',
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              else
                                const NeedsDataTable(
                                  needs: <NeedSummary>[],
                                  statusFilter: null,
                                  priorityFilter: null,
                                  isLoading: true,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(DashboardStats? stats, {bool isLoading = false}) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: <Widget>[
        SizedBox(
          width: 220,
          child: StatsCard(
            title: 'ACTIVE NEEDS',
            value: isLoading ? '--' : '${stats?.totalActiveNeeds ?? 0}',
            subtitle: isLoading ? null : 'Zone ${stats?.zoneId ?? ''}',
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.primaryBlue,
            iconBackground: AppColors.primaryBlueLight,
            isLoading: isLoading,
            badge: (stats?.criticalNeeds ?? 0) > 0 ? '${stats!.criticalNeeds} CRITICAL' : null,
          ),
        ),
        SizedBox(
          width: 220,
          child: StatsCard(
            title: 'AVAILABLE VOLUNTEERS',
            value: isLoading ? '--' : '${stats?.availableVolunteers ?? 0}',
            subtitle: isLoading
                ? null
                : '${stats?.totalVolunteers ?? 0} total registered',
            icon: Icons.people_rounded,
            iconColor: AppColors.successGreen,
            iconBackground: AppColors.successGreenLight,
            isLoading: isLoading,
          ),
        ),
        SizedBox(
          width: 220,
          child: StatsCard(
            title: 'RESOURCES ALLOCATED',
            value: isLoading ? '--' : '${stats?.resourcesAllocated ?? 0}',
            subtitle: isLoading
                ? null
                : '${stats?.totalResources ?? 0} total available',
            icon: Icons.inventory_2_rounded,
            iconColor: AppColors.warningAmber,
            iconBackground: AppColors.warningAmberLight,
            isLoading: isLoading,
          ),
        ),
        SizedBox(
          width: 220,
          child: StatsCard(
            title: 'ACTIVE INCIDENTS',
            value: isLoading ? '--' : '${stats?.activeIncidents ?? 0}',
            subtitle: isLoading ? null : '${stats?.totalIncidents ?? 0} total recorded',
            icon: Icons.crisis_alert_rounded,
            iconColor: AppColors.dangerRed,
            iconBackground: AppColors.dangerRedLight,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}

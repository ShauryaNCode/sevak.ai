// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\presentation\widgets\sidebar_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/route_constants.dart';
import '../../../../features/authentication/domain/entities/auth_user.dart';
import '../../../../features/authentication/domain/entities/user_role.dart';
import '../../../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../ui/themes/app_colors.dart';
import '../../../../ui/themes/app_spacing.dart';
import '../../../../ui/themes/app_text_styles.dart';

/// Persistent coordinator navigation sidebar with collapsible states.
class SidebarNavigation extends StatefulWidget {
  /// Creates the sidebar navigation.
  const SidebarNavigation({
    required this.user,
    required this.currentRoute,
    this.isTablet = false,
    super.key,
  });

  /// Active authenticated user.
  final AuthUser user;

  /// Current route path used to determine the active item.
  final String currentRoute;

  /// Whether to render in tablet icon-only mode.
  final bool isTablet;

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  static const String _prefsKey = 'sidebar_collapsed';
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  @override
  Widget build(BuildContext context) {
    final List<_SidebarItem> items = const <_SidebarItem>[
      _SidebarItem(Icons.dashboard_rounded, 'Overview', AppRoutes.coordinatorDashboard),
      _SidebarItem(Icons.warning_amber_rounded, 'Needs', AppRoutes.coordinatorNeeds),
      _SidebarItem(Icons.people_rounded, 'Volunteers', AppRoutes.coordinatorVolunteers),
      _SidebarItem(Icons.inventory_2_rounded, 'Resources', AppRoutes.coordinatorResources),
      _SidebarItem(Icons.map_rounded, 'Map View', AppRoutes.coordinatorMap),
    ];
    final List<_SidebarItem> trailing = const <_SidebarItem>[
      _SidebarItem(Icons.settings_rounded, 'Settings', AppRoutes.coordinatorSettings),
    ];

    if (widget.isTablet) {
      return NavigationRail(
        selectedIndex: items.indexWhere(
          (_SidebarItem item) => item.route == widget.currentRoute,
        ),
        onDestinationSelected: (int index) => context.go(items[index].route),
        backgroundColor: AppColors.sidebarBackground,
        labelType: NavigationRailLabelType.none,
        useIndicator: true,
        leading: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: CircleAvatar(
            backgroundColor: AppColors.primaryBlue,
            child: Text(
              widget.user.initials,
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
            ),
          ),
        ),
        trailing: IconButton(
          onPressed: () => context.read<AuthBloc>().add(const AuthEvent.logoutRequested()),
          icon: const Icon(Icons.logout_rounded, color: AppColors.sidebarText),
          tooltip: 'Logout',
        ),
        destinations: items
            .map(
              (_SidebarItem item) => NavigationRailDestination(
                icon: Tooltip(
                  message: item.label,
                  child: Icon(item.icon, color: AppColors.sidebarText),
                ),
                selectedIcon: Icon(item.icon, color: AppColors.sidebarActive),
                label: Text(item.label),
              ),
            )
            .toList(),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: _collapsed ? 64 : 240,
      color: AppColors.sidebarBackground,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _collapsed
                ? CircleAvatar(
                    backgroundColor: AppColors.primaryBlue,
                    child: Text(
                      widget.user.initials,
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
                    ),
                  )
                : Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: AppColors.primaryBlue,
                        child: Text(
                          widget.user.initials,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.user.zoneId,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              widget.user.role.displayName,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.sidebarText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              children: <Widget>[
                ...items.map(_buildItem),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Divider(color: AppColors.neutral600, height: 1),
                ),
                ...trailing.map(_buildItem),
                _buildLogout(),
              ],
            ),
          ),
          IconButton(
            onPressed: _toggleCollapsed,
            tooltip: _collapsed ? 'Expand sidebar' : 'Collapse sidebar',
            icon: Icon(
              _collapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
              color: AppColors.sidebarText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildItem(_SidebarItem item) {
    final bool active = widget.currentRoute == item.route;
    final Widget tile = Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: active
            ? AppColors.primaryBlue.withValues(alpha: 0.18)
            : AppColors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border(
          left: BorderSide(
            color: active ? AppColors.sidebarActive : AppColors.transparent,
            width: 4,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            _collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: _collapsed ? 44 : 40,
            child: Icon(
              item.icon,
              color: active ? AppColors.sidebarActive : AppColors.sidebarText,
              size: 20,
            ),
          ),
          if (!_collapsed)
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: active ? AppColors.sidebarActiveText : AppColors.sidebarText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );

    return Tooltip(
      message: _collapsed ? item.label : '',
      child: InkWell(
        onTap: () => context.go(item.route),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: tile,
      ),
    );
  }

  Widget _buildLogout() {
    return Tooltip(
      message: _collapsed ? 'Logout' : '',
      child: InkWell(
        onTap: () => context.read<AuthBloc>().add(const AuthEvent.logoutRequested()),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          height: 44,
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment:
                _collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: _collapsed ? 44 : 40,
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.sidebarText,
                  size: 20,
                ),
              ),
              if (!_collapsed)
                Expanded(
                  child: Text(
                    'Logout',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.sidebarText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => _collapsed = prefs.getBool(_prefsKey) ?? false);
    }
  }

  Future<void> _toggleCollapsed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool next = !_collapsed;
    await prefs.setBool(_prefsKey, next);
    if (mounted) {
      setState(() => _collapsed = next);
    }
  }
}

class _SidebarItem {
  const _SidebarItem(this.icon, this.label, this.route);

  final IconData icon;
  final String label;
  final String route;
}

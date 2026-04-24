// C:\Users\th366\Desktop\sevakai\frontend\lib\core\config\app_router.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/authentication/domain/entities/auth_user.dart';
import '../../features/authentication/domain/entities/user_role.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/presentation/screens/otp_verification_screen.dart';
import '../../features/authentication/presentation/screens/phone_input_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/operations_screens.dart';
import '../../features/volunteers/presentation/screens/volunteer_dashboard_screen.dart';
import 'route_constants.dart';

/// Auth-aware web router for SevakAI.
@lazySingleton
class AppRouter {
  /// Creates the application router and hooks it to auth state refreshes.
  AppRouter(this._authBloc) {
    _authBloc.add(const AuthEvent.appStarted());
  }

  final AuthBloc _authBloc;
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

  /// Configured `GoRouter` instance for the application.
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = _authBloc.state;
      final bool isAuthenticated = authState is AuthAuthenticated;
      final AuthUser? user =
          authState is AuthAuthenticated ? authState.user : null;
      final String location = state.matchedLocation;
      final bool isAuthRoute =
          location == AppRoutes.login || location == AppRoutes.otpVerification;

      if (location == '/') {
        return _defaultRouteForUser(user);
      }

      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isAuthRoute) {
        return _defaultRouteForUser(user);
      }

      if (location.startsWith('/coordinator') &&
          user != null &&
          _roleRank(user.role) < _roleRank(UserRole.zoneCoordinator)) {
        return AppRoutes.volunteerDashboard;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: const PhoneInputScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (BuildContext context, GoRouterState state) {
          final String phone = state.uri.queryParameters['phone'] ?? '';
          return BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: OtpVerificationScreen(phone: phone),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.coordinatorDashboard,
        builder: (BuildContext context, GoRouterState state) {
          final AuthUser user = (_authBloc.state as AuthAuthenticated).user;
          return BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: DashboardScreen(user: user),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.coordinatorNeeds,
        builder: (BuildContext context, GoRouterState state) {
          final AuthUser user = (_authBloc.state as AuthAuthenticated).user;
          return BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: CoordinatorNeedsScreen(user: user),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.coordinatorVolunteers,
        builder: (BuildContext context, GoRouterState state) {
          final AuthUser user = (_authBloc.state as AuthAuthenticated).user;
          return BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: CoordinatorVolunteersScreen(user: user),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.coordinatorResources,
        builder: (BuildContext context, GoRouterState state) {
          final AuthUser user = (_authBloc.state as AuthAuthenticated).user;
          return BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: CoordinatorResourcesScreen(user: user),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.coordinatorMap,
        builder: (BuildContext context, GoRouterState state) {
          final AuthUser user = (_authBloc.state as AuthAuthenticated).user;
          return BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: CoordinatorMapScreen(user: user),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.coordinatorSettings,
        builder: (BuildContext context, GoRouterState state) {
          final AuthUser user = (_authBloc.state as AuthAuthenticated).user;
          return BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: CoordinatorSettingsScreen(user: user),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.volunteerDashboard,
        builder: (BuildContext context, GoRouterState state) {
          final AuthUser user = (_authBloc.state as AuthAuthenticated).user;
          return BlocProvider<AuthBloc>.value(
            value: _authBloc,
            child: VolunteerDashboardScreen(user: user),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.error,
        builder: (BuildContext context, GoRouterState state) =>
            const _ErrorScreen(),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const _ErrorScreen(),
  );

  String _defaultRouteForUser(AuthUser? user) {
    if (user == null) {
      return AppRoutes.login;
    }
    if (_roleRank(user.role) >= _roleRank(UserRole.zoneCoordinator)) {
      return AppRoutes.coordinatorDashboard;
    }
    return AppRoutes.volunteerDashboard;
  }

  int _roleRank(UserRole role) {
    switch (role) {
      case UserRole.volunteer:
        return 0;
      case UserRole.zoneCoordinator:
        return 1;
      case UserRole.districtAdmin:
        return 2;
      case UserRole.nationalAdmin:
        return 3;
      case UserRole.aiSystem:
        return 4;
    }
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Placeholder screen for routes not yet implemented.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

/// Generic router error screen.
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Page not found',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

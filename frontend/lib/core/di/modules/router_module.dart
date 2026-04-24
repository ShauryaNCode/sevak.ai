// lib/core/di/modules/router_module.dart
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../config/app_router.dart';

/// Registers routing dependencies for SevakAI.
@module
abstract class RouterModule {
  /// Creates the root router configuration for the application shell.
  @lazySingleton
  GoRouter router(AppRouter appRouter) {
    return appRouter.router;
  }
}

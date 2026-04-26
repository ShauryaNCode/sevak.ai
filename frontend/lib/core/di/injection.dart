// lib/core/di/injection.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' hide dev, prod;

import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/data/sources/auth_local_source.dart';
import '../../features/authentication/data/sources/auth_remote_source.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../config/app_config.dart';
import 'injection.config.dart';

/// Global service locator for SevakAI.
final GetIt getIt = GetIt.instance;

/// Development environment name used by dependency registration.
const String kEnvDev = 'dev';

/// Staging environment name used by dependency registration.
const String kEnvStaging = 'staging';

/// Production environment name used by dependency registration.
const String kEnvProd = 'prod';

/// Injectable annotation for development-only registrations.
const Environment dev = Environment(kEnvDev);

/// Injectable annotation for staging-only registrations.
const Environment staging = Environment(kEnvStaging);

/// Injectable annotation for production-only registrations.
const Environment prod = Environment(kEnvProd);

/// Configures all dependency registrations for the requested environment.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies(String environment) async {
  getIt.init(environment: environment);
  _registerFallbackRepositories();
}

/// Injectable occasionally misses abstract repository bindings after branch
/// switches or regenerated artifacts. Registering these fallbacks keeps the
/// app bootable while preserving generated DI for the rest of the graph.
void _registerFallbackRepositories() {
  if (!getIt.isRegistered<AuthLocalSource>()) {
    getIt.registerLazySingleton<AuthLocalSource>(
      () => AuthLocalSourceImpl(getIt<FlutterSecureStorage>()),
      dispose: (AuthLocalSource source) => source.dispose(),
    );
  }

  if (!getIt.isRegistered<AuthRemoteSource>()) {
    getIt.registerLazySingleton<AuthRemoteSource>(
      () => AuthRemoteSourceImpl(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        getIt<AuthRemoteSource>(),
        getIt<AuthLocalSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<DashboardRepository>()) {
    getIt.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        getIt<Dio>(),
        getIt<AppConfig>(),
      ),
    );
  }
}

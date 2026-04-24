// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' hide dev, prod;

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
Future<void> configureDependencies(String environment) async =>
    getIt.init(environment: environment);

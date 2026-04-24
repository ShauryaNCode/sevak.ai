// lib/core/di/modules/config_module.dart
import 'package:injectable/injectable.dart';

import '../../config/app_config.dart';
import '../injection.dart';

/// Registers runtime configuration access for injectable-generated graphs.
@module
abstract class ConfigModule {
  /// Returns the development application configuration.
  @Environment(kEnvDev)
  @lazySingleton
  AppConfig get devConfig => AppConfig.dev;

  /// Returns the staging application configuration.
  @Environment(kEnvStaging)
  @lazySingleton
  AppConfig get stagingConfig => AppConfig.staging;

  /// Returns the production application configuration.
  @Environment(kEnvProd)
  @lazySingleton
  AppConfig get productionConfig => AppConfig.production;
}

// lib/core/di/modules/platform_module.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Registers platform service dependencies for SevakAI.
@module
abstract class PlatformModule {
  /// Provides the shared connectivity plugin instance.
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}

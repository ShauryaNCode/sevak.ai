// lib/core/di/modules/storage_module.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

/// Registers storage dependencies for SevakAI.
@module
abstract class StorageModule {
  /// Returns the global Hive interface used for local persistence.
  @lazySingleton
  HiveInterface get hive => Hive;

  /// Returns the encrypted secure storage instance for sensitive data.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}

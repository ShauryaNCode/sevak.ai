// lib/core/di/modules/network_module.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../config/app_config.dart';
import '../injection.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/retry_interceptor.dart';

/// Registers network-layer dependencies for SevakAI.
@module
abstract class NetworkModule {
  /// Creates a configured Dio client for API access.
  @Environment(kEnvDev)
  @Environment(kEnvStaging)
  @lazySingleton
  Dio nonProductionDio(
    AppConfig config,
    AuthInterceptor authInterceptor,
    RetryInterceptor retryInterceptor,
    LogInterceptor logInterceptor,
  ) {
    final Dio client = _createBaseClient(
      config: config,
      authInterceptor: authInterceptor,
      retryInterceptor: retryInterceptor,
    );
    client.interceptors.add(logInterceptor);
    return client;
  }

  /// Creates a configured Dio client for production API access.
  @Environment(kEnvProd)
  @lazySingleton
  Dio productionDio(
    AppConfig config,
    AuthInterceptor authInterceptor,
    RetryInterceptor retryInterceptor,
  ) {
    return _createBaseClient(
      config: config,
      authInterceptor: authInterceptor,
      retryInterceptor: retryInterceptor,
    );
  }

  /// Builds the shared base Dio client with common interceptors and timeouts.
  Dio _createBaseClient({
    required AppConfig config,
    required AuthInterceptor authInterceptor,
    required RetryInterceptor retryInterceptor,
  }) {
    log(
      'Creating Dio client with base URL ${config.apiBaseUrl}',
      name: 'SevakAI.Network',
    );

    final BaseOptions options = BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    final Dio client = Dio(options);
    client.interceptors.add(authInterceptor);
    client.interceptors.add(retryInterceptor);
    return client;
  }

  /// Creates a request log interceptor for development and staging builds.
  @Environment(kEnvDev)
  @Environment(kEnvStaging)
  @lazySingleton
  LogInterceptor logInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
      logPrint: (Object object) {
        // ignore: avoid_print
        print(object);
      },
    );
  }
}

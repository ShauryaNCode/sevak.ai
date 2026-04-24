// lib/core/di/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Intercepts outbound requests to attach authentication credentials.
@lazySingleton
class AuthInterceptor extends Interceptor {
  /// Creates the authentication interceptor placeholder.
  const AuthInterceptor();

  /// Attaches the active auth token and security headers to each request.
  ///
  /// TODO: When implemented, this method must read the latest access token
  /// from secure storage, inject an `Authorization: Bearer <token>` header,
  /// add any disaster-ops correlation metadata required by backend observability,
  /// and avoid mutating requests for endpoints that explicitly opt out of auth.
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    handler.next(options);
  }
}

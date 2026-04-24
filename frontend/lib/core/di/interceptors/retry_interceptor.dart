// lib/core/di/interceptors/retry_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Intercepts failed requests to support retry behavior for transient failures.
@lazySingleton
class RetryInterceptor extends Interceptor {
  /// Creates the retry interceptor placeholder.
  const RetryInterceptor();

  /// Retries transient failures using a bounded backoff strategy.
  ///
  /// TODO: When implemented, this method must detect network and server-side
  /// transient failures, cap retry attempts to prevent request storms during
  /// disaster conditions, apply exponential backoff with jitter, respect
  /// idempotency constraints, and surface unrecoverable failures immediately.
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    handler.next(err);
  }
}

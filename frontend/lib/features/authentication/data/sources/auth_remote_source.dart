// lib/features/authentication/data/sources/auth_remote_source.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/failures/auth_failure.dart';
import '../models/auth_user_model.dart';

/// Remote data source for SevakAI OTP authentication APIs.
///
/// This source depends on Dio and converts backend responses into typed models
/// while translating transport failures into domain-level [AuthFailure] values.
abstract class AuthRemoteSource {
  /// Requests OTP delivery for the given phone number.
  Future<void> requestOtp({required String phone});

  /// Verifies an OTP and returns the full authenticated response.
  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
  });

  /// Refreshes the access token using the refresh token.
  Future<String> refreshToken({required String refreshToken});

  /// Best-effort server logout for the current access token.
  Future<void> logout({required String accessToken});
}

/// Dio-backed implementation of [AuthRemoteSource].
@LazySingleton(as: AuthRemoteSource)
class AuthRemoteSourceImpl implements AuthRemoteSource {
  /// Creates the remote auth source.
  AuthRemoteSourceImpl(this._dio);

  final Dio _dio;
  static const String _logName = 'SevakAI.SyncEngine';

  @override
  Future<void> requestOtp({required String phone}) async {
    try {
      await _dio.post<void>(
        '/auth/otp/request',
        data: <String, String>{'phone': phone},
      );
    } on DioException catch (error, stackTrace) {
      log(
        'OTP request failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapFailure(error);
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final Response<Map<String, dynamic>> response =
          await _dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: <String, String>{
          'phone': phone,
          'otp': otp,
        },
      );

      return AuthResponseModel.fromJson(response.data ?? <String, dynamic>{});
    } on DioException catch (error, stackTrace) {
      log(
        'OTP verification failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapFailure(error);
    }
  }

  @override
  Future<String> refreshToken({required String refreshToken}) async {
    try {
      final Response<Map<String, dynamic>> response =
          await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: <String, String>{'refresh_token': refreshToken},
      );

      return (response.data?['access_token'] as String?) ?? '';
    } on DioException catch (error, stackTrace) {
      log(
        'Token refresh failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapFailure(error);
    }
  }

  @override
  Future<void> logout({required String accessToken}) async {
    try {
      await _dio.post<void>(
        '/auth/logout',
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioException catch (error, stackTrace) {
      log(
        'Remote logout failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapFailure(error);
    }
  }

  /// Converts a Dio exception into an [AuthFailure].
  AuthFailure _mapFailure(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const AuthFailure.networkError();
    }

    final int? statusCode = error.response?.statusCode;
    final Map<String, dynamic> data = error.response?.data is Map
        ? Map<String, dynamic>.from(error.response!.data! as Map)
        : <String, dynamic>{};
    final String code = (data['error'] as String?) ?? '';

    if (statusCode == 400 && code == 'INVALID_PHONE') {
      return const AuthFailure.invalidPhone();
    }

    if (statusCode == 400 && code == 'INVALID_OTP') {
      return const AuthFailure.invalidOtp();
    }

    if (statusCode == 400 && code == 'OTP_EXPIRED') {
      return const AuthFailure.otpExpired();
    }

    if (statusCode == 429 && code == 'TOO_MANY_ATTEMPTS') {
      return const AuthFailure.tooManyAttempts();
    }

    if (statusCode == 429) {
      return AuthFailure.rateLimited(
        retryAfterSeconds:
            (data['retry_after_seconds'] as int?) ??
            int.tryParse('${data['retry_after_seconds']}') ??
            60,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return AuthFailure.serverError(statusCode: statusCode);
    }

    return AuthFailure.unknown(
      message: code.isNotEmpty
          ? 'Authentication failed: $code'
          : 'Unexpected authentication error.',
    );
  }
}

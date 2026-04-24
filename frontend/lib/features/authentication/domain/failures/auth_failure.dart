// lib/features/authentication/domain/failures/auth_failure.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

/// Structured failures emitted by the authentication feature.
///
/// This union depends on `freezed` to provide exhaustive handling across the
/// domain, data, and presentation layers, ensuring OTP and token failures are
/// mapped consistently for offline-safe user flows.
@freezed
class AuthFailure with _$AuthFailure {
  /// Phone number format is invalid.
  const factory AuthFailure.invalidPhone() = InvalidPhone;

  /// The server temporarily rate-limited OTP requests.
  const factory AuthFailure.rateLimited({
    required int retryAfterSeconds,
  }) = RateLimited;

  /// OTP dispatch failed on the server side.
  const factory AuthFailure.smsSendFailed() = SmsSendFailed;

  /// Entered OTP is invalid.
  const factory AuthFailure.invalidOtp() = InvalidOtp;

  /// OTP has expired and cannot be verified anymore.
  const factory AuthFailure.otpExpired() = OtpExpired;

  /// Too many OTP verification attempts were made.
  const factory AuthFailure.tooManyAttempts() = TooManyAttempts;

  /// Refresh token flow failed.
  const factory AuthFailure.tokenRefreshFailed() = TokenRefreshFailed;

  /// The current session is no longer valid.
  const factory AuthFailure.sessionExpired() = SessionExpired;

  /// Network connectivity prevented the request from completing.
  const factory AuthFailure.networkError() = NetworkError;

  /// Backend returned a server-side error.
  const factory AuthFailure.serverError({
    required int statusCode,
  }) = ServerError;

  /// Unexpected failure with diagnostic context.
  const factory AuthFailure.unknown({
    required String message,
  }) = UnknownFailure;
}

/// Convenience helpers for user-facing auth failure handling.
extension AuthFailureX on AuthFailure {
  /// Fallback English message for the failure.
  String get userMessage => when(
        invalidPhone: () => 'Enter a valid Indian mobile number.',
        rateLimited: (int retryAfterSeconds) =>
            'Too many requests. Please wait before trying again.',
        smsSendFailed: () => 'We could not send the OTP right now. Please retry.',
        invalidOtp: () => 'The OTP you entered is incorrect.',
        otpExpired: () => 'This OTP has expired. Please request a new one.',
        tooManyAttempts: () =>
            'Too many incorrect attempts. Please request a new OTP.',
        tokenRefreshFailed: () =>
            'We could not refresh your session. Please sign in again.',
        sessionExpired: () => 'Your session has expired. Please sign in again.',
        networkError: () =>
            'No internet connection. Please try again when connectivity is available.',
        serverError: (int statusCode) =>
            'Server error ($statusCode). Please try again shortly.',
        unknown: (String message) => message,
      );

  /// Whether retrying the operation can reasonably succeed.
  bool get isRetryable => maybeWhen(
        networkError: () => true,
        serverError: (_) => true,
        smsSendFailed: () => true,
        orElse: () => false,
      );
}

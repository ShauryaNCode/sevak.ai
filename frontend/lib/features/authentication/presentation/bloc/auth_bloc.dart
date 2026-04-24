// lib/features/authentication/presentation/bloc/auth_bloc.dart
import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/request_otp_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';

part 'auth_bloc.freezed.dart';

/// BLoC coordinating OTP authentication UI flows and session restoration.
///
/// This BLoC depends on the auth use cases and repository. It preserves a
/// predictable event-to-state flow for startup restoration, OTP request,
/// verification, token refresh, and logout handling.
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Creates the auth BLoC.
  AuthBloc(
    this._requestOtpUseCase,
    this._verifyOtpUseCase,
    this._authRepository,
  ) : super(const AuthState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<OtpRequested>(_onOtpRequested);
    on<OtpVerified>(_onOtpVerified);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
  }

  final RequestOtpUseCase _requestOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final AuthRepository _authRepository;
  static const String _logName = 'SevakAI.SyncEngine';

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final AuthUser? user = await _authRepository.getCurrentUser();
      if (user == null) {
        emit(const AuthState.unauthenticated());
        return;
      }

      if (user.isTokenExpired) {
        emit(const AuthState.unauthenticated());
        return;
      }

      if (user.isTokenExpiringSoon) {
        add(const AuthEvent.tokenRefreshRequested());
      }

      emit(AuthState.authenticated(user: user));
    } catch (error, stackTrace) {
      log(
        'AppStarted handler failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      emit(AuthState.failure(
        failure: AuthFailure.unknown(message: error.toString()),
      ));
    }
  }

  Future<void> _onOtpRequested(
    OtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      final result = await _requestOtpUseCase(phone: event.phone);
      result.match(
        (AuthFailure failure) => emit(AuthState.failure(failure: failure)),
        (_) {
          final String normalized =
              RequestOtpUseCase.normalizeIndianPhone(event.phone) ?? event.phone;
          emit(AuthState.otpSent(phone: normalized));
        },
      );
    } catch (error, stackTrace) {
      log(
        'OtpRequested handler failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      emit(AuthState.failure(
        failure: AuthFailure.unknown(message: error.toString()),
      ));
    }
  }

  Future<void> _onOtpVerified(
    OtpVerified event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      final result = await _verifyOtpUseCase(
        phone: event.phone,
        otp: event.otp,
      );
      result.match(
        (AuthFailure failure) => emit(AuthState.failure(failure: failure)),
        (AuthUser user) => emit(AuthState.authenticated(user: user)),
      );
    } catch (error, stackTrace) {
      log(
        'OtpVerified handler failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      emit(AuthState.failure(
        failure: AuthFailure.unknown(message: error.toString()),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      await _authRepository.logout();
      emit(const AuthState.unauthenticated());
    } catch (error, stackTrace) {
      log(
        'LogoutRequested handler failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      emit(AuthState.failure(
        failure: AuthFailure.unknown(message: error.toString()),
      ));
    }
  }

  Future<void> _onTokenRefreshRequested(
    TokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final result = await _authRepository.refreshToken();
      await result.match(
        (AuthFailure failure) async {
          emit(AuthState.failure(failure: failure));
        },
        (_) async {
          final AuthUser? refreshedUser = await _authRepository.getCurrentUser();
          if (refreshedUser == null) {
            emit(const AuthState.unauthenticated());
            return;
          }
          emit(AuthState.authenticated(user: refreshedUser));
        },
      );
    } catch (error, stackTrace) {
      log(
        'TokenRefreshRequested handler failed.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      emit(AuthState.failure(
        failure: AuthFailure.unknown(message: error.toString()),
      ));
    }
  }
}

/// Events accepted by [AuthBloc].
@freezed
class AuthEvent with _$AuthEvent {
  /// Restores auth state when the app boots.
  const factory AuthEvent.appStarted() = AppStarted;

  /// Requests an OTP for the given phone number.
  const factory AuthEvent.otpRequested({
    required String phone,
  }) = OtpRequested;

  /// Verifies the submitted OTP.
  const factory AuthEvent.otpVerified({
    required String phone,
    required String otp,
  }) = OtpVerified;

  /// Logs out the current session.
  const factory AuthEvent.logoutRequested() = LogoutRequested;

  /// Triggers a token refresh flow.
  const factory AuthEvent.tokenRefreshRequested() = TokenRefreshRequested;
}

/// States emitted by [AuthBloc].
@freezed
class AuthState with _$AuthState {
  /// Initial uninitialized auth state.
  const factory AuthState.initial() = AuthInitial;

  /// Loading state for active auth operations.
  const factory AuthState.loading() = AuthLoading;

  /// OTP was sent successfully to the given phone number.
  const factory AuthState.otpSent({
    required String phone,
  }) = AuthOtpSent;

  /// User is authenticated.
  const factory AuthState.authenticated({
    required AuthUser user,
  }) = AuthAuthenticated;

  /// No valid session is active.
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// Auth flow failed with a typed failure.
  const factory AuthState.failure({
    required AuthFailure failure,
  }) = AuthFailureState;
}

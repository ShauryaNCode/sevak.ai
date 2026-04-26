// lib/features/authentication/data/repositories/auth_repository_impl.dart
import 'dart:convert';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_user_model.dart';
import '../sources/auth_local_source.dart';
import '../sources/auth_remote_source.dart';

/// Default authentication repository implementation.
///
/// This repository depends on remote auth APIs and secure local storage. It
/// keeps the current session durable across app launches and wraps data-layer
/// failures into domain-friendly `Either` results.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  /// Creates the auth repository implementation.
  AuthRepositoryImpl(this._remoteSource, this._localSource);

  final AuthRemoteSource _remoteSource;
  final AuthLocalSource _localSource;
  static const String _logName = 'SevakAI.SyncEngine';

  @override
  Future<Either<AuthFailure, void>> requestOtp({required String phone}) async {
    try {
      await _remoteSource.requestOtp(phone: phone);
      return right(null);
    } on AuthFailure catch (failure) {
      return left(failure);
    } catch (error, stackTrace) {
      log(
        'Unexpected requestOtp repository failure.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(AuthFailure.unknown(message: error.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, AuthUser>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final AuthResponseModel response =
          await _remoteSource.verifyOtp(phone: phone, otp: otp);
      final AuthUser user = response.toDomain();
      await _localSource.saveUser(user);
      await _localSource.saveTokens(
        access: user.accessToken,
        refresh: user.refreshToken,
        expiresAt: user.tokenExpiresAt,
      );
      return right(user);
    } on AuthFailure catch (failure) {
      return left(failure);
    } catch (error, stackTrace) {
      log(
        'Unexpected verifyOtp repository failure.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(AuthFailure.unknown(message: error.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, String>> refreshToken() async {
    try {
      final String? refreshToken = await _localSource.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return left(const AuthFailure.sessionExpired());
      }

      final String accessToken =
          await _remoteSource.refreshToken(refreshToken: refreshToken);
      if (accessToken.isEmpty) {
        return left(const AuthFailure.tokenRefreshFailed());
      }

      final AuthUser? currentUser = await _localSource.getUser();
      if (currentUser != null) {
        final DateTime expiresAt = _decodeExpiry(accessToken);
        final AuthUser updatedUser = currentUser.copyWith(
          accessToken: accessToken,
          tokenExpiresAt: expiresAt,
        );
        await _localSource.saveUser(updatedUser);
        await _localSource.saveTokens(
          access: accessToken,
          refresh: currentUser.refreshToken,
          expiresAt: expiresAt,
        );
      }

      return right(accessToken);
    } on AuthFailure catch (failure) {
      return left(failure);
    } catch (error, stackTrace) {
      log(
        'Unexpected refreshToken repository failure.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(AuthFailure.unknown(message: error.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      final String? accessToken = await _localSource.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        try {
          await _remoteSource.logout(accessToken: accessToken);
        } catch (error, stackTrace) {
          log(
            'Remote logout failed but local cleanup will continue.',
            name: _logName,
            error: error,
            stackTrace: stackTrace,
          );
        }
      }

      await _localSource.clearUser();
      await _localSource.clearTokens();
      return right(null);
    } catch (error, stackTrace) {
      log(
        'Unexpected logout repository failure.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return left(AuthFailure.unknown(message: error.toString()));
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() => _localSource.getUser();

  @override
  Stream<AuthUser?> watchAuthState() => _localSource.watchAuthState();

  @override
  Future<void> saveUser(AuthUser user) => _localSource.saveUser(user);

  /// Decodes the JWT expiry if present, otherwise falls back to one hour.
  DateTime _decodeExpiry(String accessToken) {
    try {
      final List<String> parts = accessToken.split('.');
      if (parts.length < 2) {
        return DateTime.now().toUtc().add(const Duration(hours: 1));
      }

      final String normalized = base64.normalize(parts[1]);
      final Map<String, dynamic> payload =
          jsonDecode(utf8.decode(base64Url.decode(normalized)))
              as Map<String, dynamic>;
      final Object? exp = payload['exp'];
      final int? expSeconds = exp is int ? exp : int.tryParse('$exp');
      if (expSeconds == null) {
        return DateTime.now().toUtc().add(const Duration(hours: 1));
      }

      return DateTime.fromMillisecondsSinceEpoch(
        expSeconds * 1000,
        isUtc: true,
      );
    } catch (error, stackTrace) {
      log(
        'Failed to decode JWT expiry. Falling back to default lifetime.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return DateTime.now().toUtc().add(const Duration(hours: 1));
    }
  }
}

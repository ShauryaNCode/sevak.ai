// lib/features/authentication/data/sources/auth_local_source.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_user.dart';

const String _kAccessToken = 'auth_access_token';
const String _kRefreshToken = 'auth_refresh_token';
const String _kTokenExpiresAt = 'auth_token_expires_at';
const String _kUserJson = 'auth_user_json';

/// Secure local persistence for authentication state.
///
/// This source depends on [FlutterSecureStorage] and exposes a broadcast auth
/// state stream so presentation and routing layers can react to login/logout
/// changes without polling.
abstract class AuthLocalSource {
  /// Reads the currently stored user.
  Future<AuthUser?> getUser();

  /// Persists the authenticated user object.
  Future<void> saveUser(AuthUser user);

  /// Clears the stored user object.
  Future<void> clearUser();

  /// Reads the access token.
  Future<String?> getAccessToken();

  /// Reads the refresh token.
  Future<String?> getRefreshToken();

  /// Persists the latest token set and expiry.
  Future<void> saveTokens({
    required String access,
    required String refresh,
    required DateTime expiresAt,
  });

  /// Clears stored tokens.
  Future<void> clearTokens();

  /// Watches auth state changes.
  Stream<AuthUser?> watchAuthState();

  /// Releases internal stream resources.
  Future<void> dispose();
}

/// Secure-storage implementation of [AuthLocalSource].
@LazySingleton(as: AuthLocalSource)
class AuthLocalSourceImpl implements AuthLocalSource {
  /// Creates the local auth source.
  AuthLocalSourceImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  final StreamController<AuthUser?> _controller =
      StreamController<AuthUser?>.broadcast();
  static const String _logName = 'SevakAI.SyncEngine';

  @override
  Future<AuthUser?> getUser() async {
    try {
      final String? json = await _secureStorage.read(key: _kUserJson);
      if (json == null || json.isEmpty) {
        return null;
      }

      final Map<String, dynamic> map =
          jsonDecode(json) as Map<String, dynamic>;
      return AuthUser.fromJson(map);
    } catch (error, stackTrace) {
      log(
        'Failed to read local auth user.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> saveUser(AuthUser user) async {
    try {
      await _secureStorage.write(
        key: _kUserJson,
        value: jsonEncode(user.toJson()),
      );
      _controller.add(user);
    } catch (error, stackTrace) {
      log(
        'Failed to save local auth user.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _secureStorage.delete(key: _kUserJson);
      _controller.add(null);
    } catch (error, stackTrace) {
      log(
        'Failed to clear local auth user.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return _secureStorage.read(key: _kAccessToken);
    } catch (error, stackTrace) {
      log(
        'Failed to read access token.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return _secureStorage.read(key: _kRefreshToken);
    } catch (error, stackTrace) {
      log(
        'Failed to read refresh token.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> saveTokens({
    required String access,
    required String refresh,
    required DateTime expiresAt,
  }) async {
    try {
      await _secureStorage.write(key: _kAccessToken, value: access);
      await _secureStorage.write(key: _kRefreshToken, value: refresh);
      await _secureStorage.write(
        key: _kTokenExpiresAt,
        value: expiresAt.toUtc().toIso8601String(),
      );
    } catch (error, stackTrace) {
      log(
        'Failed to save auth tokens.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _secureStorage.delete(key: _kAccessToken);
      await _secureStorage.delete(key: _kRefreshToken);
      await _secureStorage.delete(key: _kTokenExpiresAt);
    } catch (error, stackTrace) {
      log(
        'Failed to clear auth tokens.',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<AuthUser?> watchAuthState() {
    return Stream<AuthUser?>.multi(
      (MultiStreamController<AuthUser?> controller) {
        unawaited(getUser().then(controller.add));
        final StreamSubscription<AuthUser?> subscription =
            _controller.stream.listen(
          controller.add,
          onError: controller.addError,
        );
        controller.onCancel = subscription.cancel;
      },
      isBroadcast: true,
    );
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _controller.close();
  }
}

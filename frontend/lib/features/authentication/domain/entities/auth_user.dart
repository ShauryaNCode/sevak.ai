// lib/features/authentication/domain/entities/auth_user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// Immutable authenticated-user entity used across the auth feature.
///
/// This entity depends on `freezed` and JSON serialization so it can move
/// cleanly between domain logic and secure local persistence. Token fields are
/// stored on the entity to support fast auth checks without extra lookups.
@freezed
class AuthUser with _$AuthUser {
  /// Creates an authenticated user entity.
  const factory AuthUser({
    required String id,
    required String phone,
    required String name,
    required UserRole role,
    required String zoneId,
    required String languagePreference,
    required String accessToken,
    required String refreshToken,
    required DateTime tokenExpiresAt,
  }) = _AuthUser;

  /// Deserializes an authenticated user from JSON.
  factory AuthUser.fromJson(Map<String, Object?> json) =>
      _$AuthUserFromJson(json);
}

/// Convenience accessors for [AuthUser].
extension AuthUserX on AuthUser {
  /// Whether the access token is already expired.
  bool get isTokenExpired => tokenExpiresAt.isBefore(DateTime.now().toUtc());

  /// Whether the access token expires within the next five minutes.
  bool get isTokenExpiringSoon =>
      tokenExpiresAt.isBefore(DateTime.now().toUtc().add(const Duration(minutes: 5)));

  /// Two-letter initials derived from the user's name.
  String get initials {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '';
    }

    return parts
        .take(2)
        .map((String part) => part.substring(0, 1).toUpperCase())
        .join();
  }
}

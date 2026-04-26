// lib/features/authentication/data/models/auth_user_model.dart
// pubspec comment: add json_annotation: ^4.9.0 to dependencies and json_serializable to dev_dependencies.
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/entities/user_role.dart';

part 'auth_user_model.g.dart';

/// JSON model for the authenticated user profile returned by the API.
@JsonSerializable()
class AuthUserModel {
  /// Creates an auth user profile model.
  const AuthUserModel({
    required this.id,
    required this.phone,
    required this.name,
    required this.roleString,
    required this.zoneId,
    required this.languagePreference,
  });

  /// Unique user identifier.
  final String id;

  /// E.164 phone number.
  final String phone;

  /// Display name.
  final String name;

  /// Raw backend role string.
  @JsonKey(name: 'role')
  final String roleString;

  /// Disaster zone identifier.
  @JsonKey(name: 'zone_id')
  final String zoneId;

  /// Preferred language code.
  @JsonKey(name: 'language_preference')
  final String languagePreference;

  /// Creates a model from JSON.
  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  /// Serializes the model to JSON.
  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);
}

/// Full authentication response including tokens and user profile.
@JsonSerializable()
class AuthResponseModel {
  /// Creates an auth response model.
  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresInSeconds,
    required this.user,
  });

  /// Access JWT returned by the backend.
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// Refresh JWT returned by the backend.
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  /// Access token lifetime in seconds.
  @JsonKey(name: 'expires_in')
  final int expiresInSeconds;

  /// Embedded authenticated user profile.
  final AuthUserModel user;

  /// Creates an auth response model from JSON.
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  /// Serializes the auth response model to JSON.
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  /// Maps the API response into the domain [AuthUser] entity.
  AuthUser toDomain() {
    return AuthUser(
      id: user.id,
      phone: user.phone,
      name: user.name,
      role: UserRole.fromString(user.roleString),
      zoneId: user.zoneId,
      languagePreference: user.languagePreference,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiresAt: DateTime.now().toUtc().add(
        Duration(seconds: expiresInSeconds),
      ),
    );
  }
}

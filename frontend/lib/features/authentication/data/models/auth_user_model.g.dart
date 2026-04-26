// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) =>
    AuthUserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      roleString: json['role'] as String,
      zoneId: json['zone_id'] as String,
      languagePreference: json['language_preference'] as String,
    );

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'role': instance.roleString,
      'zone_id': instance.zoneId,
      'language_preference': instance.languagePreference,
    };

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresInSeconds: (json['expires_in'] as num).toInt(),
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresInSeconds,
      'user': instance.user,
    };

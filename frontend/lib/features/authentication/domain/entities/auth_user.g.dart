// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserImpl _$$AuthUserImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserImpl(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      zoneId: json['zoneId'] as String,
      languagePreference: json['languagePreference'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenExpiresAt: DateTime.parse(json['tokenExpiresAt'] as String),
    );

Map<String, dynamic> _$$AuthUserImplToJson(_$AuthUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'role': _$UserRoleEnumMap[instance.role]!,
      'zoneId': instance.zoneId,
      'languagePreference': instance.languagePreference,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenExpiresAt': instance.tokenExpiresAt.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.volunteer: 'volunteer',
  UserRole.zoneCoordinator: 'zoneCoordinator',
  UserRole.districtAdmin: 'districtAdmin',
  UserRole.nationalAdmin: 'nationalAdmin',
  UserRole.aiSystem: 'aiSystem',
};

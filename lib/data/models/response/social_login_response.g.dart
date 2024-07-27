// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialLoginResponse _$SocialLoginResponseFromJson(Map<String, dynamic> json) =>
    SocialLoginResponse(
      token: SocialLoginToken.fromJson(json['token'] as Map<String, dynamic>),
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$SocialLoginResponseToJson(
        SocialLoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserRoleEnumMap = {
  UserRole.roleTempUser: 'ROLE_TEMP_USER',
  UserRole.roleUser: 'ROLE_USER',
};

SocialLoginToken _$SocialLoginTokenFromJson(Map<String, dynamic> json) =>
    SocialLoginToken(
      accessToken: json['accessToken'] as String,
    );

Map<String, dynamic> _$SocialLoginTokenToJson(SocialLoginToken instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      id: (json['id'] as num).toInt(),
      nickname: json['nickname'] as String,
      memberIdentificationType:
          $enumDecode(_$LoginProviderEnumMap, json['memberIdentificationType']),
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      themes:
          (json['themes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'memberIdentificationType':
          _$LoginProviderEnumMap[instance.memberIdentificationType]!,
      'role': _$UserRoleEnumMap[instance.role]!,
      'themes': instance.themes,
    };

const _$LoginProviderEnumMap = {
  LoginProvider.kakao: 'KAKAO',
  LoginProvider.apple: 'APPLE',
};

const _$UserRoleEnumMap = {
  UserRole.roleTempUser: 'ROLE_TEMP_USER',
  UserRole.roleUser: 'ROLE_USER',
};

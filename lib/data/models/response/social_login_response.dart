import 'package:json_annotation/json_annotation.dart';

import '../user_role.dart';

part 'social_login_response.g.dart';

@JsonSerializable()
class SocialLoginResponse {
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'role')
  final UserRole role;

  SocialLoginResponse({
    required this.token,
    required this.role
  });

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) => _$SocialLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginResponseToJson(this);
}

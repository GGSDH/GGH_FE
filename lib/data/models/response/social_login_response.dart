import 'package:json_annotation/json_annotation.dart';

part 'social_login_response.g.dart';

@JsonSerializable()
class SocialLoginResponse {
  @JsonKey(name: 'token')
  final SocialLoginToken token;

  SocialLoginResponse({
    required this.token
  });

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) => _$SocialLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginResponseToJson(this);
}

@JsonSerializable()
class SocialLoginToken {
  @JsonKey(name: 'accessToken')
  final String accessToken;

  SocialLoginToken({
    required this.accessToken
  });

  factory SocialLoginToken.fromJson(Map<String, dynamic> json) => _$SocialLoginTokenFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginTokenToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'social_login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: 'accessToken')
  final String accessToken;

  @JsonKey(name: 'refreshToken')
  final String refreshToken;

  LoginRequest({
    required this.accessToken,
    required this.refreshToken
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
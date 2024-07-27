import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:json_annotation/json_annotation.dart';

import '../user_role.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'nickname')
  final String nickname;
  @JsonKey(name: 'memberIdentificationType')
  final LoginProvider memberIdentificationType;
  @JsonKey(name: 'role')
  final UserRole role;
  @JsonKey(name: 'themes')
  final List<String> themes;

  ProfileResponse({
    required this.id,
    required this.nickname,
    required this.memberIdentificationType,
    required this.role,
    required this.themes
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
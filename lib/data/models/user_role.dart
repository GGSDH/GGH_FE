import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  @JsonValue("ROLE_TEMP_USER")
  roleTempUser,
  @JsonValue("ROLE_USER")
  roleUser,
}
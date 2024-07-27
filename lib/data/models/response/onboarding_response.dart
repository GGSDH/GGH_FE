import 'package:json_annotation/json_annotation.dart';

part 'onboarding_response.g.dart';

@JsonSerializable()
class OnboardingTheme {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'title')
  final String title;

  OnboardingTheme({
    required this.name,
    required this.icon,
    required this.title
  });

  factory OnboardingTheme.fromJson(Map<String, dynamic> json) => _$OnboardingThemeFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardingThemeToJson(this);
}
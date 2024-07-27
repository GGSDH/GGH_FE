import 'package:json_annotation/json_annotation.dart';

part 'onboarding_request.g.dart';

@JsonSerializable()
class OnboardingRequest {
  @JsonKey(name: 'tripThemes')
  final List<String> themeIds;

  OnboardingRequest({
    required this.themeIds,
  });

  factory OnboardingRequest.fromJson(Map<String, dynamic> json) => _$OnboardingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardingRequestToJson(this);
}
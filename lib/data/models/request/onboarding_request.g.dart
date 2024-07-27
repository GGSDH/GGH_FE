// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingRequest _$OnboardingRequestFromJson(Map<String, dynamic> json) =>
    OnboardingRequest(
      themeIds: (json['tripThemes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$OnboardingRequestToJson(OnboardingRequest instance) =>
    <String, dynamic>{
      'tripThemes': instance.themeIds,
    };

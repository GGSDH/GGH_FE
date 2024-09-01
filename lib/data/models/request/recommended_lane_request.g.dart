// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_lane_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedLaneRequest _$RecommendedLaneRequestFromJson(
        Map<String, dynamic> json) =>
    RecommendedLaneRequest(
      days: (json['days'] as num).toInt(),
      sigunguCode: RecommendedLaneRequest._sigunguCodesFromJson(
          json['sigunguCode'] as List),
      tripThemeConstants: RecommendedLaneRequest._tripThemesFromJson(
          json['tripThemeConstants'] as List),
    );

Map<String, dynamic> _$RecommendedLaneRequestToJson(
        RecommendedLaneRequest instance) =>
    <String, dynamic>{
      'days': instance.days,
      'sigunguCode':
          RecommendedLaneRequest._sigunguCodesToJson(instance.sigunguCode),
      'tripThemeConstants':
          RecommendedLaneRequest._tripThemesToJson(instance.tripThemeConstants),
    };

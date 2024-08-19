// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_area_search_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TourAreaSearchRequest _$TourAreaSearchRequestFromJson(
        Map<String, dynamic> json) =>
    TourAreaSearchRequest(
      sigunguCode: SigunguCode.fromJson(json['sigunguCode'] as String),
      tripThemes: TourAreaSearchRequest._tripThemesFromJson(
          json['tripThemeConstants'] as List),
    );

Map<String, dynamic> _$TourAreaSearchRequestToJson(
        TourAreaSearchRequest instance) =>
    <String, dynamic>{
      'sigunguCode': SigunguCode.toJson(instance.sigunguCode),
      'tripThemeConstants':
          TourAreaSearchRequest._tripThemesToJson(instance.tripThemes),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_area_search_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TourAreaSearchRequest _$TourAreaSearchRequestFromJson(
        Map<String, dynamic> json) =>
    TourAreaSearchRequest(
      sigunguCode: TourAreaSearchRequest._sigunguCodesFromJson(
          json['sigunguCode'] as List),
      tripTheme: TripTheme.fromJson(json['tripThemeConstant'] as String),
    );

Map<String, dynamic> _$TourAreaSearchRequestToJson(
        TourAreaSearchRequest instance) =>
    <String, dynamic>{
      'sigunguCode':
          TourAreaSearchRequest._sigunguCodesToJson(instance.sigunguCode),
      'tripThemeConstant': TripTheme.toJson(instance.tripTheme),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_tour_area_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedTourAreaResponse _$RecommendedTourAreaResponseFromJson(
        Map<String, dynamic> json) =>
    RecommendedTourAreaResponse(
      tourAreaId: (json['tourAreaId'] as num).toInt(),
      tourAreaName: json['tourAreaName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      image: json['image'] as String,
      likeCnt: (json['likeCnt'] as num).toInt(),
      likedByMe: json['likedByMe'] as bool,
      sigunguCode: SigunguCode.fromJson(json['sigunguCode'] as String),
      tripTheme: TripTheme.fromJson(json['tripThemeConstants'] as String),
    );

Map<String, dynamic> _$RecommendedTourAreaResponseToJson(
        RecommendedTourAreaResponse instance) =>
    <String, dynamic>{
      'tourAreaId': instance.tourAreaId,
      'tourAreaName': instance.tourAreaName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'image': instance.image,
      'likeCnt': instance.likeCnt,
      'likedByMe': instance.likedByMe,
      'sigunguCode': SigunguCode.toJson(instance.sigunguCode),
      'tripThemeConstants': TripTheme.toJson(instance.tripTheme),
    };

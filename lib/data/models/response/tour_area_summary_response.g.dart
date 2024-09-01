// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_area_summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TourAreaSummary _$TourAreaSummaryFromJson(Map<String, dynamic> json) =>
    TourAreaSummary(
      tourAreaId: (json['tourAreaId'] as num).toInt(),
      tourAreaName: json['tourAreaName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      image: json['image'] as String,
      likeCnt: (json['likeCnt'] as num).toInt(),
      likedByMe: json['likedByMe'] as bool,
      sigunguCode: SigunguCode.fromJson(json['sigunguCode'] as String),
    );

Map<String, dynamic> _$TourAreaSummaryToJson(TourAreaSummary instance) =>
    <String, dynamic>{
      'tourAreaId': instance.tourAreaId,
      'tourAreaName': instance.tourAreaName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'image': instance.image,
      'likeCnt': instance.likeCnt,
      'likedByMe': instance.likedByMe,
      'sigunguCode': SigunguCode.toJson(instance.sigunguCode),
    };

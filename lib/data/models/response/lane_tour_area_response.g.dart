// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lane_tour_area_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaneTourArea _$LaneTourAreaFromJson(Map<String, dynamic> json) => LaneTourArea(
      tourAreaId: (json['tourAreaId'] as num).toInt(),
      tourAreaName: json['tourAreaName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      image: json['image'] as String,
      likeCnt: (json['likeCnt'] as num).toInt(),
      likedByMe: json['likedByMe'] as bool,
    );

Map<String, dynamic> _$LaneTourAreaToJson(LaneTourArea instance) =>
    <String, dynamic>{
      'tourAreaId': instance.tourAreaId,
      'tourAreaName': instance.tourAreaName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'image': instance.image,
      'likeCnt': instance.likeCnt,
      'likedByMe': instance.likedByMe,
    };

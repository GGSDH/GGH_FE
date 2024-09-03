// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_area_related_lane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TourAreaRelatedLane _$TourAreaRelatedLaneFromJson(Map<String, dynamic> json) =>
    TourAreaRelatedLane(
      laneId: (json['laneId'] as num).toInt(),
      name: json['name'] as String,
      photo: json['photo'] as String,
      likeCount: (json['likeCount'] as num).toInt(),
      likedByMe: json['likedByMe'] as bool,
      theme: TripTheme.fromJson(json['theme'] as String),
    );

Map<String, dynamic> _$TourAreaRelatedLaneToJson(
        TourAreaRelatedLane instance) =>
    <String, dynamic>{
      'laneId': instance.laneId,
      'name': instance.name,
      'photo': instance.photo,
      'likeCount': instance.likeCount,
      'likedByMe': instance.likedByMe,
      'theme': TripTheme.toJson(instance.theme),
    };

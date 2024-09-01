// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lane_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lane _$LaneFromJson(Map<String, dynamic> json) => Lane(
      laneId: (json['laneId'] as num).toInt(),
      laneName: json['laneName'] as String,
      category: TripTheme.fromJson(json['tripThemeConstants'] as String),
      likeCount: (json['likes'] as num).toInt(),
      image: json['image'] as String,
      days: (json['days'] as num).toInt(),
    );

Map<String, dynamic> _$LaneToJson(Lane instance) => <String, dynamic>{
      'laneId': instance.laneId,
      'laneName': instance.laneName,
      'tripThemeConstants': TripTheme.toJson(instance.category),
      'likes': instance.likeCount,
      'image': instance.image,
      'days': instance.days,
    };

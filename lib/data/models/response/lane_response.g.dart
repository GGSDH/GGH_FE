// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lane_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lane _$LaneFromJson(Map<String, dynamic> json) => Lane(
      laneId: (json['laneId'] as num).toInt(),
      laneName: json['laneName'] as String,
      category: json['category'] as String,
      likeCount: (json['likeCnt'] as num).toInt(),
      likedByMe: json['likedByMe'] as bool,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$LaneToJson(Lane instance) => <String, dynamic>{
      'laneId': instance.laneId,
      'laneName': instance.laneName,
      'category': instance.category,
      'likeCnt': instance.likeCount,
      'likedByMe': instance.likedByMe,
      'image': instance.image,
    };

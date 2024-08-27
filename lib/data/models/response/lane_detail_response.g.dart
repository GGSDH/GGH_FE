// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lane_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaneDetail _$LaneDetailFromJson(Map<String, dynamic> json) => LaneDetail(
      id: (json['id'] as num).toInt(),
      days: (json['days'] as num).toInt(),
      laneName: json['laneName'] as String,
      image: json['image'] as String,
      laneSpecificResponses: (json['laneSpecificResponses'] as List<dynamic>)
          .map((e) => LaneSpecificResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LaneDetailToJson(LaneDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'days': instance.days,
      'laneName': instance.laneName,
      'image': instance.image,
      'laneSpecificResponses':
          instance.laneSpecificResponses.map((e) => e.toJson()).toList(),
    };

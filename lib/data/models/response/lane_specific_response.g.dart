// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lane_specific_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaneSpecificResponse _$LaneSpecificResponseFromJson(
        Map<String, dynamic> json) =>
    LaneSpecificResponse(
      sequence: (json['sequence'] as num).toInt(),
      laneName: json['laneName'] as String,
      tourAreaResponse: TourAreaSummary.fromJson(
          json['tourAreaResponse'] as Map<String, dynamic>),
      day: (json['day'] as num).toInt(),
    );

Map<String, dynamic> _$LaneSpecificResponseToJson(
        LaneSpecificResponse instance) =>
    <String, dynamic>{
      'sequence': instance.sequence,
      'laneName': instance.laneName,
      'tourAreaResponse': instance.tourAreaResponse.toJson(),
      'day': instance.day,
    };
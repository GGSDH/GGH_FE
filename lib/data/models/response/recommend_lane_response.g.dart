// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_lane_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedLaneResponse _$RecommendedLaneResponseFromJson(
        Map<String, dynamic> json) =>
    RecommendedLaneResponse(
      travelPlan: TravelPlan.fromJson(json['data'] as Map<String, dynamic>),
      laneSpecificResponse:
          (json['laneSpecificResponse'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) =>
                    LaneSpecificResponse.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$RecommendedLaneResponseToJson(
        RecommendedLaneResponse instance) =>
    <String, dynamic>{
      'data': instance.travelPlan.toJson(),
      'laneSpecificResponse': instance.laneSpecificResponse
          .map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
      'id': instance.id,
    };

TravelPlan _$TravelPlanFromJson(Map<String, dynamic> json) => TravelPlan(
      title: json['title'] as String,
      description: json['description'] as String,
      days: (json['days'] as List<dynamic>)
          .map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TravelPlanToJson(TravelPlan instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'days': instance.days.map((e) => e.toJson()).toList(),
    };

DayPlan _$DayPlanFromJson(Map<String, dynamic> json) => DayPlan(
      day: (json['day'] as num).toInt(),
      tripAreaNames: (json['tripAreaNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DayPlanToJson(DayPlan instance) => <String, dynamic>{
      'day': instance.day,
      'tripAreaNames': instance.tripAreaNames,
    };

LaneSpecificResponse _$LaneSpecificResponseFromJson(
        Map<String, dynamic> json) =>
    LaneSpecificResponse(
      sequence: (json['sequence'] as num).toInt(),
      laneName: json['laneName'] as String,
      tourArea: TourAreaResponse.fromJson(
          json['tourAreaResponse'] as Map<String, dynamic>),
      day: (json['day'] as num).toInt(),
    );

Map<String, dynamic> _$LaneSpecificResponseToJson(
        LaneSpecificResponse instance) =>
    <String, dynamic>{
      'sequence': instance.sequence,
      'laneName': instance.laneName,
      'tourAreaResponse': instance.tourArea.toJson(),
      'day': instance.day,
    };

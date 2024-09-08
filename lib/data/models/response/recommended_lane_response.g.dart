// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_lane_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedLaneResponse _$RecommendedLaneResponseFromJson(
        Map<String, dynamic> json) =>
    RecommendedLaneResponse(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      days: (json['days'] as List<dynamic>)
          .map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$RecommendedLaneResponseToJson(
        RecommendedLaneResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'days': instance.days.map((e) => e.toJson()).toList(),
      'id': instance.id,
    };

DayPlan _$DayPlanFromJson(Map<String, dynamic> json) => DayPlan(
      day: (json['day'] as num).toInt(),
      tripAreaNames: (json['tripAreaNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tourAreas: (json['tourAreas'] as List<dynamic>)
          .map((e) => LaneSpecificResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DayPlanToJson(DayPlan instance) => <String, dynamic>{
      'day': instance.day,
      'tripAreaNames': instance.tripAreaNames,
      'tourAreas': instance.tourAreas.map((e) => e.toJson()).toList(),
    };

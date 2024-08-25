// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_area_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TourAreaDetail _$TourAreaDetailFromJson(Map<String, dynamic> json) =>
    TourAreaDetail(
      tourArea: TourArea.fromJson(json['tourArea'] as Map<String, dynamic>),
      lanes: (json['lanes'] as List<dynamic>)
          .map((e) => Lane.fromJson(e as Map<String, dynamic>))
          .toList(),
      otherTourAreas: (json['otherTourAreas'] as List<dynamic>)
          .map((e) => TourArea.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TourAreaDetailToJson(TourAreaDetail instance) =>
    <String, dynamic>{
      'tourArea': instance.tourArea.toJson(),
      'lanes': instance.lanes.map((e) => e.toJson()).toList(),
      'otherTourAreas': instance.otherTourAreas.map((e) => e.toJson()).toList(),
    };

import 'package:gyeonggi_express/data/models/response/recommended_tour_area_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommended_lane_response.g.dart';

@JsonSerializable()
class RecommendedLaneResponse {
  @JsonKey(name: 'title', defaultValue: '')
  final String title;
  @JsonKey(name: 'description', defaultValue: '')
  final String description;
  final List<DayPlan> days;
  final int id;

  RecommendedLaneResponse({
    required this.title,
    required this.description,
    required this.days,
    required this.id,
  });

  factory RecommendedLaneResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedLaneResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendedLaneResponseToJson(this);
}

@JsonSerializable()
class DayPlan {
  final int day;
  final List<String> tripAreaNames;
  final List<LaneSpecificResponse> tourAreas;

  DayPlan({
    required this.day,
    required this.tripAreaNames,
    required this.tourAreas,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) =>
      _$DayPlanFromJson(json);

  Map<String, dynamic> toJson() => _$DayPlanToJson(this);
}

@JsonSerializable()
class LaneSpecificResponse {
  final int sequence;
  @JsonKey(name: 'tourAreaResponse')
  final RecommendedTourAreaResponse tourArea;

  LaneSpecificResponse({
    required this.sequence,
    required this.tourArea,
  });

  factory LaneSpecificResponse.fromJson(Map<String, dynamic> json) =>
      _$LaneSpecificResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LaneSpecificResponseToJson(this);
}

import 'package:gyeonggi_express/data/models/response/tour_area_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommend_lane_response.g.dart';

@JsonSerializable()
class RecommendedLaneResponse {
  @JsonKey(name: 'data')
  final TravelPlan travelPlan;

  final Map<String, List<LaneSpecificResponse>> laneSpecificResponse;
  final int id;

  RecommendedLaneResponse({
    required this.travelPlan,
    required this.laneSpecificResponse,
    required this.id,
  });

  factory RecommendedLaneResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedLaneResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendedLaneResponseToJson(this);
}

@JsonSerializable()
class TravelPlan {
  final String title;
  final String description;
  final List<DayPlan> days;

  TravelPlan({
    required this.title,
    required this.description,
    required this.days,
  });

  factory TravelPlan.fromJson(Map<String, dynamic> json) =>
      _$TravelPlanFromJson(json);

  Map<String, dynamic> toJson() => _$TravelPlanToJson(this);
}

@JsonSerializable()
class DayPlan {
  final int day;
  final List<String> tripAreaNames;

  DayPlan({
    required this.day,
    required this.tripAreaNames,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) =>
      _$DayPlanFromJson(json);

  Map<String, dynamic> toJson() => _$DayPlanToJson(this);
}

@JsonSerializable()
class LaneSpecificResponse {
  final int sequence;
  final String laneName;

  @JsonKey(name: 'tourAreaResponse')
  final TourAreaResponse tourArea;

  final int day;

  LaneSpecificResponse({
    required this.sequence,
    required this.laneName,
    required this.tourArea,
    required this.day,
  });

  factory LaneSpecificResponse.fromJson(Map<String, dynamic> json) =>
      _$LaneSpecificResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LaneSpecificResponseToJson(this);
}
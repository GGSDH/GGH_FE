import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lane_specific_response.g.dart';

@JsonSerializable()
class LaneSpecificResponse {
  @JsonKey(name: 'sequence')
  final int sequence;

  @JsonKey(name: 'tourAreaResponse')
  final TourAreaSummary tourAreaResponse;

  @JsonKey(name: 'day')
  final int day;

  LaneSpecificResponse({
    required this.sequence,
    required this.tourAreaResponse,
    required this.day,
  });

  LaneSpecificResponse copyWith({
    int? sequence,
    TourAreaSummary? tourAreaResponse,
    int? day,
  }) {
    return LaneSpecificResponse(
      sequence: sequence ?? this.sequence,
      tourAreaResponse: tourAreaResponse ?? this.tourAreaResponse,
      day: day ?? this.day,
    );
  }

  factory LaneSpecificResponse.fromJson(Map<String, dynamic> json) =>
      _$LaneSpecificResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LaneSpecificResponseToJson(this);
}

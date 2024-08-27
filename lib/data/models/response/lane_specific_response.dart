import 'package:gyeonggi_express/data/models/response/lane_tour_area_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lane_specific_response.g.dart';

@JsonSerializable()
class LaneSpecificResponse {
  @JsonKey(name: 'sequence')
  final int sequence;

  @JsonKey(name: 'laneName')
  final String laneName;

  @JsonKey(name: 'tourAreaResponse')
  final LaneTourArea tourAreaResponse;

  @JsonKey(name: 'day')
  final int day;

  LaneSpecificResponse({
    required this.sequence,
    required this.laneName,
    required this.tourAreaResponse,
    required this.day,
  });

  factory LaneSpecificResponse.fromJson(Map<String, dynamic> json) =>
      _$LaneSpecificResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LaneSpecificResponseToJson(this);
}

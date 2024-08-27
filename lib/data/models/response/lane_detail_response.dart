import 'package:gyeonggi_express/data/models/response/lane_specific_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lane_detail_response.g.dart';

@JsonSerializable()
class LaneDetail {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'days')
  final int days;

  @JsonKey(name: 'laneName')
  final String laneName;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'laneSpecificResponses')
  final List<LaneSpecificResponse> laneSpecificResponses;

  LaneDetail({
    required this.id,
    required this.days,
    required this.laneName,
    required this.image,
    required this.laneSpecificResponses,
  });

  factory LaneDetail.fromJson(Map<String, dynamic> json) =>
      _$LaneDetailFromJson(json);
  Map<String, dynamic> toJson() => _$LaneDetailToJson(this);
}

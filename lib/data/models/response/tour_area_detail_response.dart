import 'package:gyeonggi_express/data/models/response/lane_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_related_lane.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tour_area_detail_response.g.dart';

@JsonSerializable()
class TourAreaDetail {
  @JsonKey(name: 'tourArea')
  final TourAreaResponse tourArea;
  @JsonKey(name: 'lanes')
  final List<TourAreaRelatedLane> lanes;
  @JsonKey(name: 'otherTourAreas')
  final List<TourAreaResponse> otherTourAreas;

  TourAreaDetail({
    required this.tourArea,
    required this.lanes,
    required this.otherTourAreas,
  });

  factory TourAreaDetail.fromJson(Map<String, dynamic> json) =>
      _$TourAreaDetailFromJson(json);

  Map<String, dynamic> toJson() => _$TourAreaDetailToJson(this);
}

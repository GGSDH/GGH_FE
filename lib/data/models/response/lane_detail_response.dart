import 'package:gyeonggi_express/data/models/response/lane_specific_response.dart';
import 'package:gyeonggi_express/data/models/response/lane_tour_area_response.dart';
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

  List<LaneTourArea> getTourAreasByDay(int day) {
    List<LaneSpecificResponse> responsesForDay =
        laneSpecificResponses.where((response) => response.day == day).toList();
    if (responsesForDay.isEmpty) {
      return [];
    }
    responsesForDay.sort((a, b) => a.sequence.compareTo(b.sequence));

    List<LaneTourArea> tourAreas =
        responsesForDay.map((response) => response.tourAreaResponse).toList();

    return tourAreas;
  }

  List<int> getDaysWithTourAreas() {
    Set<int> daysWithTourAreas = {};

    for (var response in laneSpecificResponses) {
      daysWithTourAreas.add(response.day);
    }

    List<int> sortedDays = daysWithTourAreas.toList()..sort();
    return sortedDays;
  }
}

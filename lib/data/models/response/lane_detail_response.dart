import 'package:gyeonggi_express/data/models/response/lane_specific_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';
import 'package:gyeonggi_express/data/models/trip_theme.dart';
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

  @JsonKey(name: 'laneDescription')
  final String? laneDescription;

  @JsonKey(
      name: 'tripThemeConstants',
      fromJson: TripTheme.fromJson,
      toJson: TripTheme.toJson)
  final TripTheme category;

  @JsonKey(name: 'laneSpecificResponses')
  final List<LaneSpecificResponse> laneSpecificResponses;

  LaneDetail({
    required this.id,
    required this.days,
    required this.laneName,
    required this.image,
    required this.laneDescription,
    required this.category,
    required this.laneSpecificResponses,
  });

  factory LaneDetail.fromJson(Map<String, dynamic> json) =>
      _$LaneDetailFromJson(json);
  Map<String, dynamic> toJson() => _$LaneDetailToJson(this);

  LaneDetail copyWith({
    int? id,
    int? days,
    String? laneName,
    String? image,
    String? laneDescription,
    TripTheme? category,
    List<LaneSpecificResponse>? laneSpecificResponses,
  }) {
    return LaneDetail(
      id: id ?? this.id,
      days: days ?? this.days,
      laneName: laneName ?? this.laneName,
      image: image ?? this.image,
      laneDescription: laneDescription ?? this.laneDescription,
      category: category ?? this.category,
      laneSpecificResponses: laneSpecificResponses ?? this.laneSpecificResponses,
    );
  }

  List<TourAreaSummary> getTourAreasByDay(int day) {
    List<LaneSpecificResponse> responsesForDay =
        laneSpecificResponses.where((response) => response.day == day).toList();
    if (responsesForDay.isEmpty) {
      return [];
    }
    responsesForDay.sort((a, b) => a.sequence.compareTo(b.sequence));

    List<TourAreaSummary> tourAreas =
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

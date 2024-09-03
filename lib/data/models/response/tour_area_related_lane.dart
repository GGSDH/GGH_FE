import 'package:gyeonggi_express/data/models/trip_theme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tour_area_related_lane.g.dart';

@JsonSerializable()
class TourAreaRelatedLane {
  @JsonKey(name: 'laneId')
  final int laneId;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'photo')
  final String photo;

  @JsonKey(name: 'likeCount')
  final int likeCount;

  @JsonKey(name: 'likedByMe')
  final bool likedByMe;

  @JsonKey(
      name: 'theme', fromJson: TripTheme.fromJson, toJson: TripTheme.toJson)
  final TripTheme theme;

  TourAreaRelatedLane({
    required this.laneId,
    required this.name,
    required this.photo,
    required this.likeCount,
    required this.likedByMe,
    required this.theme,
  });

  factory TourAreaRelatedLane.fromJson(Map<String, dynamic> json) =>
      _$TourAreaRelatedLaneFromJson(json);

  Map<String, dynamic> toJson() => _$TourAreaRelatedLaneToJson(this);
}

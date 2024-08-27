import 'package:json_annotation/json_annotation.dart';

part 'lane_tour_area_response.g.dart';

@JsonSerializable()
class LaneTourArea {
  @JsonKey(name: 'tourAreaId')
  final int tourAreaId;

  @JsonKey(name: 'tourAreaName')
  final String tourAreaName;

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'likeCnt')
  final int likeCnt;

  @JsonKey(name: 'likedByMe')
  final bool likedByMe;

  LaneTourArea({
    required this.tourAreaId,
    required this.tourAreaName,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.likeCnt,
    required this.likedByMe,
  });

  factory LaneTourArea.fromJson(Map<String, dynamic> json) =>
      _$LaneTourAreaFromJson(json);
  Map<String, dynamic> toJson() => _$LaneTourAreaToJson(this);
}

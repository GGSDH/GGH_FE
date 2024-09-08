import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:json_annotation/json_annotation.dart';

import '../trip_theme.dart';

part 'tour_area_summary_response.g.dart';

@JsonSerializable()
class TourAreaSummary {
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

  @JsonKey(
      name: 'sigunguCode',
      fromJson: SigunguCode.fromJson,
      toJson: SigunguCode.toJson)
  final SigunguCode sigunguCode;

  @JsonKey(name: 'tripThemeConstants', fromJson: TripTheme.fromJson, toJson: TripTheme.toJson)
  final TripTheme tripTheme;

  TourAreaSummary({
    required this.tourAreaId,
    required this.tourAreaName,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.likeCnt,
    required this.likedByMe,
    required this.sigunguCode,
    required this.tripTheme,
  });

  factory TourAreaSummary.fromJson(Map<String, dynamic> json) =>
      _$TourAreaSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$TourAreaSummaryToJson(this);

  TourAreaSummary copyWith({
    int? tourAreaId,
    String? tourAreaName,
    double? latitude,
    double? longitude,
    String? image,
    int? likeCnt,
    bool? likedByMe,
    SigunguCode? sigunguCode,
    TripTheme? tripTheme,
  }) {
    return TourAreaSummary(
      tourAreaId: tourAreaId ?? this.tourAreaId,
      tourAreaName: tourAreaName ?? this.tourAreaName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      image: image ?? this.image,
      likeCnt: likeCnt ?? this.likeCnt,
      likedByMe: likedByMe ?? this.likedByMe,
      sigunguCode: sigunguCode ?? this.sigunguCode,
      tripTheme: tripTheme ?? this.tripTheme,
    );
  }
}

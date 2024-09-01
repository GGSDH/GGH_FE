import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:json_annotation/json_annotation.dart';

import '../trip_theme.dart';

part 'recommended_lane_request.g.dart';

@JsonSerializable()
class RecommendedLaneRequest {
  @JsonKey(name: 'days')
  final int days;

  @JsonKey(name: 'sigunguCode', fromJson: _sigunguCodesFromJson, toJson: _sigunguCodesToJson)
  final List<SigunguCode> sigunguCode;

  @JsonKey(name: 'tripThemeConstants', fromJson: _tripThemesFromJson, toJson: _tripThemesToJson)
  final List<TripTheme> tripThemeConstants;

  RecommendedLaneRequest({
    required this.days,
    required this.sigunguCode,
    required this.tripThemeConstants,
  });

  factory RecommendedLaneRequest.fromJson(Map<String, dynamic> json) =>
      _$RecommendedLaneRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendedLaneRequestToJson(this);

  static List<SigunguCode> _sigunguCodesFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => SigunguCode.fromJson(e as String)).toList();
  }

  static List<String> _sigunguCodesToJson(List<SigunguCode> sigunguCode) {
    return sigunguCode.map((e) => SigunguCode.toJson(e)).toList();
  }

  static List<TripTheme> _tripThemesFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => TripTheme.fromJson(e as String)).toList();
  }

  static List<String> _tripThemesToJson(List<TripTheme> tripThemeConstants) {
    return tripThemeConstants.map((e) => TripTheme.toJson(e)).toList();
  }
}
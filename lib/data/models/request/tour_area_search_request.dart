import 'package:json_annotation/json_annotation.dart';

import '../sigungu_code.dart';
import '../trip_theme.dart';

part 'tour_area_search_request.g.dart';

@JsonSerializable()
class TourAreaSearchRequest {
  @JsonKey(name: 'sigunguCode', fromJson: SigunguCode.fromJson, toJson: SigunguCode.toJson)
  final SigunguCode sigunguCode;

  @JsonKey(name: 'tripThemeConstants', fromJson: _tripThemesFromJson, toJson: _tripThemesToJson)
  final List<TripTheme> tripThemes;

  TourAreaSearchRequest({
    required this.sigunguCode,
    required this.tripThemes,
  });

  factory TourAreaSearchRequest.fromJson(Map<String, dynamic> json) => _$TourAreaSearchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TourAreaSearchRequestToJson(this);

  static List<TripTheme> _tripThemesFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => TripTheme.fromJson(e as String)).toList();
  }

  static List<String> _tripThemesToJson(List<TripTheme> tripThemes) {
    return tripThemes.map((e) => TripTheme.toJson(e)).toList();
  }
}

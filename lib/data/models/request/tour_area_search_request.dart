import 'package:json_annotation/json_annotation.dart';

import '../sigungu_code.dart';
import '../trip_theme.dart';

part 'tour_area_search_request.g.dart';

@JsonSerializable()
class TourAreaSearchRequest {
  @JsonKey(name: 'sigunguCode', fromJson: _sigunguCodesFromJson, toJson: _sigunguCodesToJson)
  final List<SigunguCode> sigunguCode;

  @JsonKey(name: 'tripThemeConstant', fromJson: TripTheme.fromJson, toJson: TripTheme.toJson)
  final TripTheme tripTheme;

  TourAreaSearchRequest({
    required this.sigunguCode,
    required this.tripTheme,
  });

  factory TourAreaSearchRequest.fromJson(Map<String, dynamic> json) => _$TourAreaSearchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TourAreaSearchRequestToJson(this);

  static List<SigunguCode> _sigunguCodesFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => SigunguCode.fromJson(e as String)).toList();
  }

  static List<String> _sigunguCodesToJson(List<SigunguCode> sigunguCode) {
    return sigunguCode.map((e) => SigunguCode.toJson(e)).toList();
  }
}

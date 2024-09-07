import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/data/models/trip_theme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'keyword_search_result_response.g.dart';

@JsonSerializable()
class KeywordSearchResult {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(
      name: 'tripThemeConstants',
      fromJson: TripTheme.fromJson,
      toJson: TripTheme.toJson)
  final TripTheme tripThemeConstants;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(
      name: 'sigunguCode',
      fromJson: SigunguCode.fromJson,
      toJson: SigunguCode.toJson)
  final SigunguCode sigunguCode;

  KeywordSearchResult({
    required this.id,
    required this.type,
    required this.tripThemeConstants,
    required this.name,
    required this.sigunguCode,
  });

  factory KeywordSearchResult.fromJson(Map<String, dynamic> json) =>
      _$KeywordSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$KeywordSearchResultToJson(this);
}

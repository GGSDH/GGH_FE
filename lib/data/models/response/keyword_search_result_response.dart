import 'package:json_annotation/json_annotation.dart';

part 'keyword_search_result_response.g.dart';

@JsonSerializable()
class KeywordSearchResult {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'tripThemeConstants')
  final String tripThemeConstants;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'sigunguCode')
  final String sigunguCode;

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

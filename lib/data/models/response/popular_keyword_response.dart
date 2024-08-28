import 'package:json_annotation/json_annotation.dart';

part 'popular_keyword_response.g.dart';

@JsonSerializable()
class PopularKeyword {
  @JsonKey(name: 'keyword')
  final String keyword;
  @JsonKey(name: 'count')
  final int count;

  PopularKeyword({required this.keyword, required this.count});

  factory PopularKeyword.fromJson(Map<String, dynamic> json) =>
      _$PopularKeywordFromJson(json);

  Map<String, dynamic> toJson() => _$PopularKeywordToJson(this);
}

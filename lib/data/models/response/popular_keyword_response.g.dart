// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_keyword_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularKeyword _$PopularKeywordFromJson(Map<String, dynamic> json) =>
    PopularKeyword(
      keyword: json['keyword'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$PopularKeywordToJson(PopularKeyword instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'count': instance.count,
    };

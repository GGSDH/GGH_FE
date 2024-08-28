// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword_search_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeywordSearchResult _$KeywordSearchResultFromJson(Map<String, dynamic> json) =>
    KeywordSearchResult(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      tripThemeConstants: json['tripThemeConstants'] as String,
      name: json['name'] as String,
      sigunguCode: json['sigunguCode'] as String,
    );

Map<String, dynamic> _$KeywordSearchResultToJson(
        KeywordSearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'tripThemeConstants': instance.tripThemeConstants,
      'name': instance.name,
      'sigunguCode': instance.sigunguCode,
    };

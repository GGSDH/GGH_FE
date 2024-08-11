// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_destination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularDestination _$PopularDestinationFromJson(Map<String, dynamic> json) =>
    PopularDestination(
      ranking: (json['ranking'] as num).toInt(),
      image: json['image'] as String?,
      name: json['name'] as String,
      sigunguValue: json['sigunguValue'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$PopularDestinationToJson(PopularDestination instance) =>
    <String, dynamic>{
      'ranking': instance.ranking,
      'image': instance.image,
      'name': instance.name,
      'sigunguValue': instance.sigunguValue,
      'category': instance.category,
    };

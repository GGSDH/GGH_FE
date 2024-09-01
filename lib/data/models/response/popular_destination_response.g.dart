// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_destination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularDestination _$PopularDestinationFromJson(Map<String, dynamic> json) =>
    PopularDestination(
      tourAreaId: (json['tourAreaId'] as num).toInt(),
      ranking: (json['ranking'] as num).toInt(),
      image: json['image'] as String?,
      name: json['name'] as String,
      sigunguValue: json['sigunguValue'] as String,
      category: TripTheme.fromJson(json['category'] as String),
    );

Map<String, dynamic> _$PopularDestinationToJson(PopularDestination instance) =>
    <String, dynamic>{
      'tourAreaId': instance.tourAreaId,
      'ranking': instance.ranking,
      'image': instance.image,
      'name': instance.name,
      'sigunguValue': instance.sigunguValue,
      'category': TripTheme.toJson(instance.category),
    };

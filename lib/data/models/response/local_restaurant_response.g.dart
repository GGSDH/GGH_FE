// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_restaurant_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalRestaurant _$LocalRestaurantFromJson(Map<String, dynamic> json) =>
    LocalRestaurant(
      tourAreaId: (json['tourAreaId'] as num).toInt(),
      image: json['image'] as String?,
      name: json['name'] as String,
      likeCount: (json['likeCnt'] as num).toInt(),
      sigunguValue: json['sigunguValue'] as String,
      likedByMe: json['likedByMe'] as bool,
    );

Map<String, dynamic> _$LocalRestaurantToJson(LocalRestaurant instance) =>
    <String, dynamic>{
      'tourAreaId': instance.tourAreaId,
      'image': instance.image,
      'name': instance.name,
      'likeCnt': instance.likeCount,
      'sigunguValue': instance.sigunguValue,
      'likedByMe': instance.likedByMe,
    };

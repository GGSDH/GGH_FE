// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_area_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TourAreaResponse _$TourAreaResponseFromJson(Map<String, dynamic> json) =>
    TourAreaResponse(
      tourAreaId: (json['tourAreaId'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      image: json['image'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      ranking: (json['ranking'] as num?)?.toInt(),
      sigungu: SigunguCode.fromJson(json['sigungu'] as String),
      telNo: json['telNo'] as String?,
      tripTheme: TripTheme.fromJson(json['tripTheme'] as String),
      likeCount: (json['likeCount'] as num).toInt(),
      likedByMe: json['likedByMe'] as bool,
      contentType: TourContentType.fromJson(json['contentType'] as String),
    );

Map<String, dynamic> _$TourAreaResponseToJson(TourAreaResponse instance) =>
    <String, dynamic>{
      'tourAreaId': instance.tourAreaId,
      'name': instance.name,
      'address': instance.address,
      'image': instance.image,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'ranking': instance.ranking,
      'sigungu': SigunguCode.toJson(instance.sigungu),
      'telNo': instance.telNo,
      'tripTheme': TripTheme.toJson(instance.tripTheme),
      'likeCount': instance.likeCount,
      'likedByMe': instance.likedByMe,
      'contentType': TourContentType.toJson(instance.contentType),
    };

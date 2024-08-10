// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_photobook_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPhotobookRequest _$AddPhotobookRequestFromJson(Map<String, dynamic> json) =>
    AddPhotobookRequest(
      title: json['title'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      photos: (json['photos'] as List<dynamic>)
          .map((e) => AddPhotoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddPhotobookRequestToJson(
        AddPhotobookRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'photos': instance.photos,
    };

AddPhotoItem _$AddPhotoItemFromJson(Map<String, dynamic> json) => AddPhotoItem(
      timestamp: json['timestamp'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      path: json['path'] as String,
    );

Map<String, dynamic> _$AddPhotoItemToJson(AddPhotoItem instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'path': instance.path,
    };

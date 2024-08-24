// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_photobook_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RandomPhotobookResponse _$RandomPhotobookResponseFromJson(
        Map<String, dynamic> json) =>
    RandomPhotobookResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      startDateTime: json['startDateTime'] as String,
      endDateTime: json['endDateTime'] as String,
      photos: (json['photos'] as List<dynamic>)
          .map((e) => PhotoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyPhotoGroups: (json['dailyPhotoGroups'] as List<dynamic>)
          .map((e) => DailyPhotoGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RandomPhotobookResponseToJson(
        RandomPhotobookResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDateTime': instance.startDateTime,
      'endDateTime': instance.endDateTime,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'dailyPhotoGroups':
          instance.dailyPhotoGroups.map((e) => e.toJson()).toList(),
    };

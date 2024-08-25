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
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      photos: (json['photos'] as List<dynamic>)
          .map((e) => PhotoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyPhotoGroups: (json['dailyPhotoGroups'] as List<dynamic>)
          .map((e) => DailyPhotoGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: LocationItem.fromJson(json['location'] as Map<String, dynamic>),
      photoTicketImage: json['photoTicketImage'] == null
          ? null
          : PhotoItem.fromJson(
              json['photoTicketImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RandomPhotobookResponseToJson(
        RandomPhotobookResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'dailyPhotoGroups':
          instance.dailyPhotoGroups.map((e) => e.toJson()).toList(),
      'location': instance.location.toJson(),
      'photoTicketImage': instance.photoTicketImage?.toJson(),
    };

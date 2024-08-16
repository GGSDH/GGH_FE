// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photobook_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotobookDetailResponse _$PhotobookDetailResponseFromJson(
        Map<String, dynamic> json) =>
    PhotobookDetailResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      dailyPhotoGroup: (json['dailyPhotoGroup'] as List<dynamic>)
          .map((e) => DailyPhotoGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PhotobookDetailResponseToJson(
        PhotobookDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'dailyPhotoGroup':
          instance.dailyPhotoGroup.map((e) => e.toJson()).toList(),
    };

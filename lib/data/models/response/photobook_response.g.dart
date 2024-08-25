// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photobook_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotobookResponse _$PhotobookResponseFromJson(Map<String, dynamic> json) =>
    PhotobookResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      dailyPhotoGroup: (json['dailyPhotoGroup'] as List<dynamic>?)
              ?.map((e) => DailyPhotoGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mainPhoto: json['mainPhoto'] == null
          ? null
          : PhotoItem.fromJson(json['mainPhoto'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : LocationItem.fromJson(json['location'] as Map<String, dynamic>),
      photoTicketImage: json['photoTicketImage'] == null
          ? null
          : PhotoItem.fromJson(
              json['photoTicketImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PhotobookResponseToJson(PhotobookResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'dailyPhotoGroup':
          instance.dailyPhotoGroup.map((e) => e.toJson()).toList(),
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'mainPhoto': instance.mainPhoto?.toJson(),
      'location': instance.location?.toJson(),
      'photoTicketImage': instance.photoTicketImage?.toJson(),
    };

DailyPhotoGroup _$DailyPhotoGroupFromJson(Map<String, dynamic> json) =>
    DailyPhotoGroup(
      day: (json['day'] as num).toInt(),
      dateTime: json['dateTime'] as String,
      hourlyPhotoGroups: (json['hourlyPhotoGroups'] as List<dynamic>?)
              ?.map((e) => HourlyPhotoGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DailyPhotoGroupToJson(DailyPhotoGroup instance) =>
    <String, dynamic>{
      'day': instance.day,
      'dateTime': instance.dateTime,
      'hourlyPhotoGroups':
          instance.hourlyPhotoGroups.map((e) => e.toJson()).toList(),
    };

HourlyPhotoGroup _$HourlyPhotoGroupFromJson(Map<String, dynamic> json) =>
    HourlyPhotoGroup(
      dateTime: json['dateTime'] as String,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      photosCount: (json['photosCount'] as num).toInt(),
      localizedTime: json['localizedTime'] as String,
      dominantLocation: json['dominantLocation'] == null
          ? null
          : LocationItem.fromJson(
              json['dominantLocation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HourlyPhotoGroupToJson(HourlyPhotoGroup instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'photosCount': instance.photosCount,
      'localizedTime': instance.localizedTime,
      'dominantLocation': instance.dominantLocation?.toJson(),
    };

PhotoItem _$PhotoItemFromJson(Map<String, dynamic> json) => PhotoItem(
      id: json['id'] as String,
      path: json['path'] as String,
      location: json['location'] == null
          ? null
          : LocationItem.fromJson(json['location'] as Map<String, dynamic>),
      dateTime: json['dateTime'] as String,
      isPhototicket: json['isPhototicket'] as bool,
    );

Map<String, dynamic> _$PhotoItemToJson(PhotoItem instance) => <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'location': instance.location?.toJson(),
      'dateTime': instance.dateTime,
      'isPhototicket': instance.isPhototicket,
    };

LocationItem _$LocationItemFromJson(Map<String, dynamic> json) => LocationItem(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      name: json['name'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$LocationItemToJson(LocationItem instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'name': instance.name,
      'city': instance.city,
    };

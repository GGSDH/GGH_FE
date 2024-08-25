// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_ticket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoTicketResponse _$PhotoTicketResponseFromJson(Map<String, dynamic> json) =>
    PhotoTicketResponse(
      photoBook: PhotoTicketPhotoBookResponse.fromJson(
          json['photoBook'] as Map<String, dynamic>),
      photoTicket:
          PhotoTicket.fromJson(json['phototicket'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PhotoTicketResponseToJson(
        PhotoTicketResponse instance) =>
    <String, dynamic>{
      'photoBook': instance.photoBook.toJson(),
      'phototicket': instance.photoTicket.toJson(),
    };

PhotoTicketPhotoBookResponse _$PhotoTicketPhotoBookResponseFromJson(
        Map<String, dynamic> json) =>
    PhotoTicketPhotoBookResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      startDate: json['startDateTime'] as String,
      endDate: json['endDateTime'] as String,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      dailyPhotoGroup: (json['dailyPhotoGroup'] as List<dynamic>?)
              ?.map((e) => DailyPhotoGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      location: LocationItem.fromJson(json['location'] as Map<String, dynamic>),
      photoTicket: json['photoTicket'] == null
          ? null
          : PhotoTicket.fromJson(json['photoTicket'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PhotoTicketPhotoBookResponseToJson(
        PhotoTicketPhotoBookResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDateTime': instance.startDate,
      'endDateTime': instance.endDate,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'dailyPhotoGroup':
          instance.dailyPhotoGroup.map((e) => e.toJson()).toList(),
      'location': instance.location.toJson(),
      'photoTicket': instance.photoTicket?.toJson(),
    };

PhotoTicket _$PhotoTicketFromJson(Map<String, dynamic> json) => PhotoTicket(
      id: json['id'] as String,
      path: json['path'] as String,
      location: LocationItem.fromJson(json['location'] as Map<String, dynamic>),
      dateTime: json['dateTime'] as String,
      isPhototicket: json['isPhototicket'] as bool,
    );

Map<String, dynamic> _$PhotoTicketToJson(PhotoTicket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'location': instance.location.toJson(),
      'dateTime': instance.dateTime,
      'isPhototicket': instance.isPhototicket,
    };

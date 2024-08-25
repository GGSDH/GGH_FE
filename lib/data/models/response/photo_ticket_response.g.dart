// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_ticket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoTicketResponse _$PhotoTicketResponseFromJson(Map<String, dynamic> json) =>
    PhotoTicketResponse(
      photobook:
          PhotobookResponse.fromJson(json['photoBook'] as Map<String, dynamic>),
      photo: PhotoItem.fromJson(json['photo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PhotoTicketResponseToJson(
        PhotoTicketResponse instance) =>
    <String, dynamic>{
      'photoBook': instance.photobook.toJson(),
      'photo': instance.photo.toJson(),
    };

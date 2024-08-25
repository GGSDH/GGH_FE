// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photobook_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photobook _$PhotobookFromJson(Map<String, dynamic> json) => Photobook(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      photo: json['photo'] as String,
      location: LocationItem.fromJson(json['location'] as Map<String, dynamic>),
      photoTicketImage: json['photoTicketImage'] == null
          ? null
          : PhotoTicket.fromJson(
              json['photoTicketImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PhotobookToJson(Photobook instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'photo': instance.photo,
      'location': instance.location.toJson(),
      'photoTicketImage': instance.photoTicketImage?.toJson(),
    };

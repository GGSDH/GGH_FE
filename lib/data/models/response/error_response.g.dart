// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      timeStamp: json['timeStamp'] as String,
      errorCode: json['errorCode'] as String,
      errorMessage: json['errorMessage'] as String,
      details: json['details'],
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'timeStamp': instance.timeStamp,
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'details': instance.details,
    };

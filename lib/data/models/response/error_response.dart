import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  @JsonKey(name: 'timeStamp')
  final String timeStamp;

  @JsonKey(name: 'errorCode')
  final String errorCode;

  @JsonKey(name: 'errorMessage')
  final String errorMessage;

  @JsonKey(name: 'details')
  final dynamic details;

  ErrorResponse({
    required this.timeStamp,
    required this.errorCode,
    required this.errorMessage,
    required this.details
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

}
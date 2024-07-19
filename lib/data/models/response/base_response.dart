import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  @JsonKey(name: 'result')
  final bool isSuccess;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final T data;

  BaseResponse({
    required this.isSuccess,
    required this.message,
    required this.data
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT
  ) => _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
    _$BaseResponseToJson(this, toJsonT);
}
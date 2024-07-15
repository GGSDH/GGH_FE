import 'package:json_annotation/json_annotation.dart';

part 'common_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CommonResponse<T> {
  @JsonKey(name: 'isSuccess')
  final bool isSuccess;

  @JsonKey(name: 'code')
  final String code;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'result')
  final T result;

  CommonResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result
  });

  factory CommonResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT
  ) => _$CommonResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
    _$CommonResponseToJson(this, toJsonT);
}
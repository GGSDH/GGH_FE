import 'package:json_annotation/json_annotation.dart';

part 'photobook_list_response.g.dart';

@JsonSerializable()
class Photobook {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'startDate')
  final String startDate;

  @JsonKey(name: 'endDate')
  final String endDate;

  @JsonKey(name: 'photo')
  final String photo;

  @JsonKey(name: 'location')
  final String location;

  Photobook({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.photo,
    required this.location,
  });

  factory Photobook.fromJson(Map<String, dynamic> json) =>
      _$PhotobookFromJson(json);

  Map<String, dynamic> toJson() => _$PhotobookToJson(this);
}
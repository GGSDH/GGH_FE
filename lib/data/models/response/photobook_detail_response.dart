import 'package:json_annotation/json_annotation.dart';

import 'add_photobook_response.dart';

part 'photobook_detail_response.g.dart';

@JsonSerializable()
class PhotobookDetailResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'startDate')
  final String startDate;

  @JsonKey(name: 'endDate')
  final String endDate;

  @JsonKey(name: 'dailyPhotoGroup')
  final List<DailyPhotoGroup> dailyPhotoGroup;

  PhotobookDetailResponse({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.dailyPhotoGroup,
  });

  factory PhotobookDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotobookDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhotobookDetailResponseToJson(this);
}
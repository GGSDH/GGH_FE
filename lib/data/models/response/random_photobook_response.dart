import 'package:json_annotation/json_annotation.dart';

import 'add_photobook_response.dart';

part 'random_photobook_response.g.dart';

@JsonSerializable()
class RandomPhotobookResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'startDateTime')
  final String startDateTime;

  @JsonKey(name: 'endDateTime')
  final String endDateTime;

  @JsonKey(name: 'photos')
  final List<PhotoItem> photos;

  @JsonKey(name: 'dailyPhotoGroups')
  final List<DailyPhotoGroup> dailyPhotoGroups;

  RandomPhotobookResponse({
    required this.id,
    required this.title,
    required this.startDateTime,
    required this.endDateTime,
    required this.photos,
    required this.dailyPhotoGroups,
  });

  factory RandomPhotobookResponse.fromJson(Map<String, dynamic> json) =>
      _$RandomPhotobookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RandomPhotobookResponseToJson(this);
}
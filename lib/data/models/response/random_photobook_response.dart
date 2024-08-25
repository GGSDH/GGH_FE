import 'package:json_annotation/json_annotation.dart';

import 'add_photobook_response.dart';

part 'random_photobook_response.g.dart';

@JsonSerializable()
class RandomPhotobookResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'startDate')
  final String startDate;

  @JsonKey(name: 'endDate')
  final String endDate;

  @JsonKey(name: 'photos')
  final List<PhotoItem> photos;

  @JsonKey(name: 'dailyPhotoGroups')
  final List<DailyPhotoGroup> dailyPhotoGroups;

  @JsonKey(name: 'location')
  final LocationItem location;

  @JsonKey(name: 'photoTicketImage')
  final PhotoItem? photoTicketImage;

  RandomPhotobookResponse({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.photos,
    required this.dailyPhotoGroups,
    required this.location,
    required this.photoTicketImage,
  });

  factory RandomPhotobookResponse.fromJson(Map<String, dynamic> json) =>
      _$RandomPhotobookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RandomPhotobookResponseToJson(this);
}
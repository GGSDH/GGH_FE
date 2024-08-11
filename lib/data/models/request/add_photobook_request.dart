import 'package:json_annotation/json_annotation.dart';

part 'add_photobook_request.g.dart';

@JsonSerializable()
class AddPhotobookRequest {
  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'startDate')
  final String startDate;

  @JsonKey(name: 'endDate')
  final String endDate;

  @JsonKey(name: 'photos')
  final List<AddPhotoItem> photos;

  AddPhotobookRequest({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.photos,
  });

  factory AddPhotobookRequest.fromJson(Map<String, dynamic> json) => _$AddPhotobookRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddPhotobookRequestToJson(this);
}

@JsonSerializable()
class AddPhotoItem {
  @JsonKey(name: 'timestamp')
  final String timestamp;

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'path')
  final String path;

  AddPhotoItem({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.path,
  });

  factory AddPhotoItem.fromJson(Map<String, dynamic> json) => _$AddPhotoItemFromJson(json);

  Map<String, dynamic> toJson() => _$AddPhotoItemToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'photobook_response.g.dart';

@JsonSerializable()
class PhotobookResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'startDate')
  final String startDate;

  @JsonKey(name: 'endDate')
  final String endDate;

  @JsonKey(name: 'dailyPhotoGroup', defaultValue: [])
  final List<DailyPhotoGroup> dailyPhotoGroup;

  @JsonKey(name: 'photos', defaultValue: [])
  final List<PhotoItem> photos;

  @JsonKey(name: 'mainPhoto')
  final PhotoItem? mainPhoto;

  @JsonKey(name: 'location')
  final LocationItem? location;

  @JsonKey(name: 'photoTicketImage')
  final PhotoItem? photoTicketImage;

  PhotobookResponse({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.dailyPhotoGroup,
    required this.photos,
    this.mainPhoto,
    this.location,
    this.photoTicketImage,
  });

  factory PhotobookResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotobookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhotobookResponseToJson(this);
}

@JsonSerializable()
class DailyPhotoGroup {
  @JsonKey(name: 'day')
  final int day;

  @JsonKey(name: 'dateTime')
  final String dateTime;

  @JsonKey(name: 'hourlyPhotoGroups', defaultValue: [])
  final List<HourlyPhotoGroup> hourlyPhotoGroups;

  DailyPhotoGroup({
    required this.day,
    required this.dateTime,
    required this.hourlyPhotoGroups,
  });

  factory DailyPhotoGroup.fromJson(Map<String, dynamic> json) =>
      _$DailyPhotoGroupFromJson(json);

  Map<String, dynamic> toJson() => _$DailyPhotoGroupToJson(this);
}

@JsonSerializable()
class HourlyPhotoGroup {
  @JsonKey(name: 'dateTime')
  final String dateTime;

  @JsonKey(name: 'photos', defaultValue: [])
  final List<PhotoItem> photos;

  @JsonKey(name: 'photosCount')
  final int photosCount;

  @JsonKey(name: 'localizedTime')
  final String localizedTime;

  @JsonKey(name: 'dominantLocation')
  final LocationItem? dominantLocation;

  HourlyPhotoGroup({
    required this.dateTime,
    required this.photos,
    required this.photosCount,
    required this.localizedTime,
    this.dominantLocation,
  });

  factory HourlyPhotoGroup.fromJson(Map<String, dynamic> json) =>
      _$HourlyPhotoGroupFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyPhotoGroupToJson(this);
}

@JsonSerializable()
class PhotoItem {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'path')
  final String path;

  @JsonKey(name: 'location')
  final LocationItem? location;

  @JsonKey(name: 'dateTime')
  final String dateTime;

  @JsonKey(name: 'isPhototicket')
  final bool isPhototicket;

  PhotoItem({
    required this.id,
    required this.path,
    this.location,
    required this.dateTime,
    required this.isPhototicket,
  });

  factory PhotoItem.fromJson(Map<String, dynamic> json) =>
      _$PhotoItemFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoItemToJson(this);
}

@JsonSerializable()
class LocationItem {
  @JsonKey(name: 'lat', defaultValue: 0.0)
  final double lat;

  @JsonKey(name: 'lon', defaultValue: 0.0)
  final double lon;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'city')
  final String? city;

  LocationItem({
    required this.lat,
    required this.lon,
    this.name,
    this.city,
  });

  factory LocationItem.fromJson(Map<String, dynamic> json) =>
      _$LocationItemFromJson(json);

  Map<String, dynamic> toJson() => _$LocationItemToJson(this);
}

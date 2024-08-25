import 'package:json_annotation/json_annotation.dart';

import 'add_photobook_response.dart';

part 'photo_ticket_response.g.dart';

@JsonSerializable()
class PhotoTicketResponse {
  @JsonKey(name: 'photoBook')
  final PhotoTicketPhotoBookResponse photoBook;

  @JsonKey(name: 'phototicket')
  final PhotoTicket photoTicket;

  PhotoTicketResponse({
    required this.photoBook,
    required this.photoTicket,
  });

  factory PhotoTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotoTicketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoTicketResponseToJson(this);
}

@JsonSerializable()
class PhotoTicketPhotoBookResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'startDateTime')
  final String startDate;

  @JsonKey(name: 'endDateTime')
  final String endDate;

  @JsonKey(name: 'photos', defaultValue: [])
  final List<PhotoItem> photos;

  @JsonKey(name: 'dailyPhotoGroup', defaultValue: [])
  final List<DailyPhotoGroup> dailyPhotoGroup;

  @JsonKey(name: 'location')
  final LocationItem location;

  @JsonKey(name: 'photoTicket')
  final PhotoTicket? photoTicket;

  PhotoTicketPhotoBookResponse({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.photos,
    required this.dailyPhotoGroup,
    required this.location,
    required this.photoTicket,
  });

  factory PhotoTicketPhotoBookResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotoTicketPhotoBookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoTicketPhotoBookResponseToJson(this);
}

@JsonSerializable()
class PhotoTicket {
  final String id;
  final String path;
  final LocationItem location;
  final String dateTime;
  final bool isPhototicket;

  PhotoTicket({
    required this.id,
    required this.path,
    required this.location,
    required this.dateTime,
    required this.isPhototicket,
  });

  factory PhotoTicket.fromJson(Map<String, dynamic> json) =>
      _$PhotoTicketFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoTicketToJson(this);
}

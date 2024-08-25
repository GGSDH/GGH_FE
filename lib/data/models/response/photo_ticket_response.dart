import 'package:json_annotation/json_annotation.dart';

import 'photobook_response.dart';

part 'photo_ticket_response.g.dart';

@JsonSerializable()
class PhotoTicketResponse {
  @JsonKey(name: 'photoBook')
  final PhotobookResponse photobook;

  @JsonKey(name: 'photo')
  final PhotoItem photo;

  PhotoTicketResponse({
    required this.photobook,
    required this.photo,
  });

  factory PhotoTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$PhotoTicketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoTicketResponseToJson(this);
}

import 'package:gyeonggi_express/data/models/tour_content_type.dart';
import 'package:json_annotation/json_annotation.dart';
import '../sigungu_code.dart';
import '../trip_theme.dart';

part 'tour_area_response.g.dart';

@JsonSerializable()
class TourAreaResponse {
  @JsonKey(name: 'tourAreaId')
  final int tourAreaId;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'image') // null이면 생략
  final String? image;

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'ranking') // null이면 생략
  final int? ranking;

  @JsonKey(name: 'sigungu', fromJson: SigunguCode.fromJson, toJson: SigunguCode.toJson)
  final SigunguCode sigungu;

  @JsonKey(name: 'telNo') // null이면 생략
  final String? telNo;

  @JsonKey(name: 'tripTheme', fromJson: TripTheme.fromJson, toJson: TripTheme.toJson)
  final TripTheme tripTheme;

  @JsonKey(name: 'likeCount')
  final int likeCount;

  @JsonKey(name: 'likedByMe')
  final bool likedByMe;

  @JsonKey(name: 'contentType', fromJson: TourContentType.fromJson, toJson: TourContentType.toJson)
  final TourContentType contentType;

  TourAreaResponse({
    required this.tourAreaId,
    required this.name,
    required this.address,
    this.image,
    required this.latitude,
    required this.longitude,
    this.ranking,
    required this.sigungu,
    this.telNo,
    required this.tripTheme,
    required this.likeCount,
    required this.likedByMe,
    required this.contentType,
  });

  // fromJson 메서드 생성
  factory TourAreaResponse.fromJson(Map<String, dynamic> json) => _$TourAreaResponseFromJson(json);

  // toJson 메서드 생성
  Map<String, dynamic> toJson() => _$TourAreaResponseToJson(this);
}

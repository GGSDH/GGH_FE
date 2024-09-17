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

  @JsonKey(
      name: 'sigungu',
      fromJson: SigunguCode.fromJson,
      toJson: SigunguCode.toJson)
  final SigunguCode sigungu;

  @JsonKey(name: 'telNo') // null이면 생략
  final String? telNo;

  @JsonKey(
      name: 'tripTheme', fromJson: TripTheme.fromJson, toJson: TripTheme.toJson)
  final TripTheme tripTheme;

  @JsonKey(name: 'likeCount')
  final int likeCount;

  @JsonKey(name: 'likedByMe')
  final bool likedByMe;

  @JsonKey(
      name: 'contentType',
      fromJson: TourContentType.fromJson,
      toJson: TourContentType.toJson)
  final TourContentType contentType;

  @JsonKey(name: 'description')
  final String description;

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
    required this.description,
  });

  // fromJson 메서드 생성
  factory TourAreaResponse.fromJson(Map<String, dynamic> json) =>
      _$TourAreaResponseFromJson(json);

  // toJson 메서드 생성
  Map<String, dynamic> toJson() => _$TourAreaResponseToJson(this);

  TourAreaResponse copyWith({
    int? tourAreaId,
    String? name,
    String? address,
    String? image,
    double? latitude,
    double? longitude,
    int? ranking,
    SigunguCode? sigungu,
    String? telNo,
    TripTheme? tripTheme,
    int? likeCount,
    bool? likedByMe,
    TourContentType? contentType,
    String? description,
  }) {
    return TourAreaResponse(
      tourAreaId: tourAreaId ?? this.tourAreaId,
      name: name ?? this.name,
      address: address ?? this.address,
      image: image ?? this.image,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ranking: ranking ?? this.ranking,
      sigungu: sigungu ?? this.sigungu,
      telNo: telNo ?? this.telNo,
      tripTheme: tripTheme ?? this.tripTheme,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
      contentType: contentType ?? this.contentType,
      description: description ?? this.description,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'recommended_tour_area_response.g.dart';

@JsonSerializable()
class RecommendedTourAreaResponse {
  @JsonKey(name: 'tourAreaId')
  final int tourAreaId;

  @JsonKey(name: 'tourAreaName')
  final String tourAreaName;

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'likeCnt')
  final int likeCnt;

  @JsonKey(name: 'likedByMe')
  final bool likedByMe;

  @JsonKey(name: 'sigunguCode')
  final String sigunguCode;

  RecommendedTourAreaResponse({
    required this.tourAreaId,
    required this.tourAreaName,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.likeCnt,
    required this.likedByMe,
    required this.sigunguCode,
  });

  // JSON 데이터를 Dart 객체로 변환하는 팩토리 생성자
  factory RecommendedTourAreaResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedTourAreaResponseFromJson(json);

  // Dart 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$RecommendedTourAreaResponseToJson(this);
}

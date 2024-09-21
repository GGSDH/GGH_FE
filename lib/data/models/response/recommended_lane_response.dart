import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:json_annotation/json_annotation.dart';

import 'lane_specific_response.dart';

part 'recommended_lane_response.g.dart';

@JsonSerializable()
class RecommendedLaneResponse {
  @JsonKey(name: 'title', defaultValue: '')
  final String title;
  @JsonKey(name: 'description', defaultValue: '')
  final String description;
  final List<DayPlan> days;
  final int id;
  @JsonKey(name: 'sigunguCode', fromJson: _sigunguCodeFromJson, toJson: _sigunguCodeToJson)
  final List<SigunguCode> sigunguCode;

  RecommendedLaneResponse({
    required this.title,
    required this.description,
    required this.days,
    required this.id,
    required this.sigunguCode,
  });

  factory RecommendedLaneResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedLaneResponseFromJson(json);

  static List<SigunguCode> _sigunguCodeFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => SigunguCode.fromJson(e as String)).toList();
  }

  static List<String> _sigunguCodeToJson(List<SigunguCode> sigunguCode) {
    return sigunguCode.map((e) => SigunguCode.toJson(e)).toList();
  }

  Map<String, dynamic> toJson() => _$RecommendedLaneResponseToJson(this);

  RecommendedLaneResponse updateLikeStatusOfStation(int stationId, bool likeStatus) {
    final updatedDays = days.map((dayPlan) {
      final updatedTourAreas = dayPlan.tourAreas.map((tourAreaResponse) {
        if (tourAreaResponse.tourAreaResponse.tourAreaId == stationId) {
          final updatedLikedByMe = likeStatus;
          final updatedLikeCnt = likeStatus
              ? tourAreaResponse.tourAreaResponse.likeCnt + 1
              : tourAreaResponse.tourAreaResponse.likeCnt - 1;

          return tourAreaResponse.copyWith(
            tourAreaResponse: tourAreaResponse.tourAreaResponse.copyWith(
              likedByMe: updatedLikedByMe,
              likeCnt: updatedLikeCnt,
            ),
          );
        }
        return tourAreaResponse;
      }).toList();

      return dayPlan.copyWith(tourAreas: updatedTourAreas);
    }).toList();

    // 업데이트된 days 리스트를 가진 새로운 RecommendedLaneResponse 반환
    return RecommendedLaneResponse(
      title: title,
      description: description,
      days: updatedDays,
      id: id,
      sigunguCode: sigunguCode,
    );
  }
}

@JsonSerializable()
class DayPlan {
  final int day;
  final List<String> tripAreaNames;
  final List<LaneSpecificResponse> tourAreas;

  DayPlan({
    required this.day,
    required this.tripAreaNames,
    required this.tourAreas,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) =>
      _$DayPlanFromJson(json);

  DayPlan copyWith({
    int? day,
    List<String>? tripAreaNames,
    List<LaneSpecificResponse>? tourAreas,
  }) {
    return DayPlan(
      day: day ?? this.day,
      tripAreaNames: tripAreaNames ?? this.tripAreaNames,
      tourAreas: tourAreas ?? this.tourAreas,
    );
  }

  Map<String, dynamic> toJson() => _$DayPlanToJson(this);
}

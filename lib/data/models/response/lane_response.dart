import 'package:json_annotation/json_annotation.dart';

import '../trip_theme.dart';

part 'lane_response.g.dart';

@JsonSerializable()
class Lane {
  @JsonKey(name: 'laneId')
  final int laneId;

  @JsonKey(name: 'laneName')
  final String laneName;

  @JsonKey(
      name: 'tripThemeConstants',
      fromJson: TripTheme.fromJson,
      toJson: TripTheme.toJson)
  final TripTheme category;

  @JsonKey(name: 'likes')
  final int likeCount;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'days')
  final int days;

  @JsonKey(name: 'likedByMe')
  final bool likedByMe;

  Lane({
    required this.laneId,
    required this.laneName,
    required this.category,
    required this.likeCount,
    required this.image,
    required this.days,
    required this.likedByMe,
  });

  factory Lane.fromJson(Map<String, dynamic> json) => _$LaneFromJson(json);

  Map<String, dynamic> toJson() => _$LaneToJson(this);

  String getPeriodString() {
    if (days == 1) {
      return "당일치기";
    } else if (days == 2) {
      return "1박2일";
    } else {
      return "${days - 1}박$days일";
    }
  }

  Lane copyWith({
    int? laneId,
    String? laneName,
    TripTheme? category,
    int? likeCount,
    String? image,
    int? days,
    bool? likedByMe,
  }) {
    return Lane(
      laneId: laneId ?? this.laneId,
      laneName: laneName ?? this.laneName,
      category: category ?? this.category,
      likeCount: likeCount ?? this.likeCount,
      image: image ?? this.image,
      days: days ?? this.days,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }
}

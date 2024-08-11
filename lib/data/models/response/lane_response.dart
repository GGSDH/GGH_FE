import 'package:json_annotation/json_annotation.dart';

part 'lane_response.g.dart';

@JsonSerializable()
class Lane {
  @JsonKey(name: 'laneId')
  final int laneId;
  @JsonKey(name: 'laneName')
  final String laneName;
  @JsonKey(name: 'category')
  final String category;
  @JsonKey(name: 'likeCnt')
  final int likeCount;
  @JsonKey(name: 'likedByMe')
  final bool likedByMe;
  @JsonKey(name: 'image')
  final String? image;

  Lane({
    required this.laneId,
    required this.laneName,
    required this.category,
    required this.likeCount,
    required this.likedByMe,
    this.image,
  });

  factory Lane.fromJson(Map<String, dynamic> json) => _$LaneFromJson(json);

  Map<String, dynamic> toJson() => _$LaneToJson(this);
}
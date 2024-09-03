import 'package:json_annotation/json_annotation.dart';

part 'local_restaurant_response.g.dart';

@JsonSerializable()
class LocalRestaurant {
  @JsonKey(name: 'tourAreaId')
  final int tourAreaId;
  @JsonKey(name: 'image')
  final String? image;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'likeCnt')
  final int likeCount;
  @JsonKey(name: 'sigunguValue')
  final String sigunguValue;
  @JsonKey(name: 'likedByMe')
  final bool likedByMe;

  LocalRestaurant({
    required this.tourAreaId,
    this.image,
    required this.name,
    required this.likeCount,
    required this.sigunguValue,
    required this.likedByMe,
  });

  factory LocalRestaurant.fromJson(Map<String, dynamic> json) =>
      _$LocalRestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$LocalRestaurantToJson(this);

  LocalRestaurant copyWith({
    int? tourAreaId,
    String? image,
    String? name,
    int? likeCount,
    String? sigunguValue,
    bool? likedByMe,
  }) {
    return LocalRestaurant(
      tourAreaId: tourAreaId ?? this.tourAreaId,
      image: image ?? this.image,
      name: name ?? this.name,
      likeCount: likeCount ?? this.likeCount,
      sigunguValue: sigunguValue ?? this.sigunguValue,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }
}

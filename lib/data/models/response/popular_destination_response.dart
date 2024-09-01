import 'package:json_annotation/json_annotation.dart';

import '../trip_theme.dart';

part 'popular_destination_response.g.dart';

@JsonSerializable()
class PopularDestination {
  @JsonKey(name: 'tourAreaId')
  final int tourAreaId;
  @JsonKey(name: 'ranking')
  final int ranking;
  @JsonKey(name: 'image')
  final String? image;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'sigunguValue')
  final String sigunguValue;
  @JsonKey(
      name: 'category', fromJson: TripTheme.fromJson, toJson: TripTheme.toJson)
  final TripTheme category;

  PopularDestination({
    required this.tourAreaId,
    required this.ranking,
    this.image,
    required this.name,
    required this.sigunguValue,
    required this.category,
  });

  factory PopularDestination.fromJson(Map<String, dynamic> json) =>
      _$PopularDestinationFromJson(json);

  Map<String, dynamic> toJson() => _$PopularDestinationToJson(this);
}

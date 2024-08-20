enum TourContentType {
  TOURISM_SPOT("관광지"),
  FESTIVAL_EVENT("행사"),
  RESTAURANT("음식점");

  final String value;

  const TourContentType(this.value);

  static String toJson(TourContentType type) => type.name;

  static TourContentType fromJson(String json) =>
      TourContentType.values.firstWhere((e) => e.name == json);
}
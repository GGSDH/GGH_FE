enum TripTheme {
  NATURAL("자연", "🌿"),
  CULTURE("문화", "🎭"),
  REPORTS("레포츠", "🏃‍♂️"),
  SHOPPING("쇼핑", "🛒"),
  RESTAURANT("음식점", "🍽️");

  final String title;
  final String icon;

  const TripTheme(this.title, this.icon);

  static String toJson(TripTheme theme) => theme.name;

  static TripTheme fromJson(String json) =>
      TripTheme.values.firstWhere((e) => e.name == json);
}
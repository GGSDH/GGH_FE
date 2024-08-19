enum SigunguCode {
  GAPYEONG(1, "가평군"),
  GOYANG(2, "고양시"),
  GWACHEON(3, "과천시"),
  GWANGMYEONG(4, "광명시"),
  GWANGJU(5, "광주시"),
  GURI(6, "구리시"),
  GUNPO(7, "군포시"),
  GIMPO(8, "김포시"),
  NAMYANGJU(9, "남양주시"),
  DONGDUCHEON(10, "동두천시"),
  BUCHEON(11, "부천시"),
  SEONGNAM(12, "성남시"),
  SUWON(13, "수원시"),
  SIHEUNG(14, "시흥시"),
  ANSAN(15, "안산시"),
  ANSEONG(16, "안성시"),
  ANYANG(17, "안양시"),
  YANGJU(18, "양주시"),
  YANGPYEONG(19, "양평군"),
  YEOJU(20, "여주시"),
  YEONCHEON(21, "연천군"),
  OSAN(22, "오산시"),
  YONGIN(23, "용인시"),
  UIWANG(24, "의왕시"),
  UIJEONGBU(25, "의정부시"),
  ICHEON(26, "이천시"),
  PAJU(27, "파주시"),
  PYEONGTAEK(28, "평택시"),
  POCHEON(29, "포천시"),
  HANAM(30, "하남시"),
  HWASEONG(31, "화성시"),
  UNKNOWN(100, "알 수 없음");

  final int id;
  final String value;

  const SigunguCode(this.id, this.value);

  // JSON serialization method: converts to the name of the enum
  static String toJson(SigunguCode sigunguCode) => sigunguCode.name;

  // JSON deserialization method: converts from the name to the corresponding enum
  static SigunguCode fromJson(String json) =>
      SigunguCode.values.firstWhere((e) => e.name == json);

  // You can also add this method to get an enum by key
  static SigunguCode fromId(int id) =>
      SigunguCode.values.firstWhere((e) => e.id == id, orElse: () => SigunguCode.UNKNOWN);
}

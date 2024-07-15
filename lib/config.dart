import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static late final String kakaoNativeAppKey;
  static late final String baseUrl;

  static Future<void> init() async {
    await dotenv.load(fileName: "assets/config/.env");
    kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'] as String;
    baseUrl = dotenv.env['BASE_URL'] as String;
  }
}
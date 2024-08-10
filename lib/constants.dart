import 'package:flutter_naver_map/flutter_naver_map.dart';

class Constants {
  static const String LOCATION_INFO_TERMS_URL = "https://puzzled-double-b9a.notion.site/c2897bf932044183bd3603e12e4e8dc5?pvs=4";
  static const String TERMS_OF_USE_URL = "https://puzzled-double-b9a.notion.site/1e5f142ff938418cb40016eee1ff7610?pvs=4";
  static const String PRIVACY_POLICY_URL = "https://puzzled-double-b9a.notion.site/0c643687a9c84632af0207c02f72cf55?pvs=4";

  static const String ACCESS_TOKEN_KEY = "access_token";

  static const NCameraPosition DEFAULT_CAMERA_POSITION = NCameraPosition(
    target: NLatLng(37.5666102, 126.9783881),
    zoom: 8,
  );
}
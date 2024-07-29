import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gyeonggi_express/config.dart';
import 'package:gyeonggi_express/routes.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'data/di/data_module.dart';

Future<void> main() async {
  setupLocator();
  await Config.init();

  KakaoSdk.init(
    nativeAppKey: Config.kakaoNativeAppKey,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: Config.naverClientId,
    onAuthFailed: (e) {
      log("NaverMapSdk auth failed: $e");
    },
  );

  runApp(const GyeonggiExpressApp());
}

class GyeonggiExpressApp extends StatelessWidget {
  const GyeonggiExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(fontFamily: "Pretendard"),
      routerConfig: Routes.config,
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gyeonggi_express/config.dart';
import 'package:gyeonggi_express/routes.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'data/di/data_module.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  await Config.init();

  KakaoSdk.init(
    nativeAppKey: Config.kakaoNativeAppKey,
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
      /*home: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LoginScreen()
        )
      ),*/
    );
  }
}

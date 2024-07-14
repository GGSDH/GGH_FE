import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gyeonggi_express/routes.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: "assets/config/.env");
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'] as String,
  );

  FlutterNativeSplash.remove();
  runApp(const GyeonggiExpressApp());
}

class GyeonggiExpressApp extends StatelessWidget {
  const GyeonggiExpressApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: "Pretendard"
      ),
      routerConfig: Routes.config,
      /*home: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LoginScreen()
        )
      ),*/
    );
  }
}
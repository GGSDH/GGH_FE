import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gyeonggi_express/ui/login/login_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
  runApp(const GyeonggiExpressApp());
}

class GyeonggiExpressApp extends StatelessWidget {
  const GyeonggiExpressApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Pretendard"
      ),
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LoginScreen()
        )
      ),
    );
  }
}
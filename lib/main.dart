import 'package:flutter/material.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';

void main() {
  runApp(const GyeonggiExpressApp());
}

class GyeonggiExpressApp extends StatelessWidget {
  const GyeonggiExpressApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Pretendard"
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            "경기행",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: ColorStyles.primary
            )
          ),
        )
      ),
    );
  }
}
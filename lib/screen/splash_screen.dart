import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1778FB)
        ),
        child: Align(
          alignment: const Alignment(0.0, -7.0 / 25.0),
          child: SvgPicture.asset(
            "assets/icons/ic_splash_logo.svg",
            width: 205,
            height: 85,
          ),
        )
      ),
    );
  }
}
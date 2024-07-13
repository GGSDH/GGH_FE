import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 2초 후에 LoginScreen으로 이동
    Future.delayed(const Duration(seconds: 2), () {
      context.go('/login');
    });

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
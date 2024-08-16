import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';

import '../../routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Navigate to LoginScreen after a 2-second delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        GoRouter.of(context).go(Routes.login.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1778FB),
        ),
        child: Align(
          alignment: const Alignment(0.0, -0.33),
          child: SvgPicture.asset(
            "assets/icons/ic_splash_logo.svg",
            width: 205,
            height: 85,
          ),
        ),
      ),
    );
  }
}

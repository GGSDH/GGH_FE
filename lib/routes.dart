import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/router_observer.dart';
import 'package:gyeonggi_express/ui/login/login_screen.dart';
import 'package:gyeonggi_express/ui/splash/splash_screen.dart';

enum Routes {
  splash, login;

  static final GoRouter config = GoRouter(
    initialLocation: '/',
    observers: [RouterObserver()],
    routes: [
      GoRoute(
        path: '/',
        name: Routes.splash.name,
        builder: (context, state) => const SplashScreen()
      ),

      // 여기에 회원가입/로그인 플로우 넣을 예정
      ShellRoute(
        observers: [RouterObserver()],
        builder: (context, state, child) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(child: child)
        ),
        routes: [
          GoRoute(
            path: '/login',
            name: Routes.login.name,
            builder: (context, state) => const LoginScreen()
          )
        ]
      )
    ]
  );
}
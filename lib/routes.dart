import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/component/bottom_navigation_bar.dart';
import 'package:gyeonggi_express/router_observer.dart';
import 'package:gyeonggi_express/ui/home/home_screen.dart';
import 'package:gyeonggi_express/ui/login/login_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_screen.dart';
import 'package:gyeonggi_express/ui/signup/signup_screen.dart';
import 'package:gyeonggi_express/ui/splash/splash_screen.dart';

enum Routes {
  splash,
  login,
  signup,
  home,
  recommend,
  photobook,
  mypage;

  static final GoRouter config = GoRouter(initialLocation: '/', observers: [
    RouterObserver()
  ], routes: [
    GoRoute(
        path: '/',
        name: Routes.splash.name,
        builder: (context, state) => const SplashScreen()),

    // 여기에 회원가입/로그인 플로우 넣을 예정
    ShellRoute(
        observers: [RouterObserver()],
        builder: (context, state, child) => Scaffold(
            backgroundColor: Colors.white, body: SafeArea(child: child)),
        routes: [
          GoRoute(
              path: '/login',
              name: Routes.login.name,
              builder: (context, state) => const LoginScreen()),
          GoRoute(
              path: "/signup",
              name: Routes.signup.name,
              builder: (context, state) => const SignupScreen())
        ]),

    // 탭 루트 화면들
    ShellRoute(
        observers: [RouterObserver()],
        builder: (context, state, child) => Scaffold(
            backgroundColor: Colors.white,
            body: Scaffold(
              body: child,
              bottomNavigationBar: CustomBottomNavigationBar(
                currentIndex: 0,
                onTap: (index) {
                  if (index == 0) {
                    context.go('/home');
                  } else if (index == 1) {
                    context.go('/recommend');
                  } else if (index == 2) {
                    context.go('/photobook');
                  } else if (index == 3) {
                    context.go('/mypage');
                  }
                },
              ),
            )),
        routes: [
          GoRoute(
              path: '/home',
              name: Routes.home.name,
              builder: (context, state) => const HomeScreen()),
          GoRoute(
              path: '/recommend',
              name: Routes.recommend.name,
              builder: (context, state) => const RecommendScreen()),
          GoRoute(
              path: '/photobook',
              name: Routes.photobook.name,
              builder: (context, state) => const PhotobookScreen()),
          GoRoute(
              path: '/mypage',
              name: Routes.mypage.name,
              builder: (context, state) => const MyPageScreen())
        ])
  ]);
}

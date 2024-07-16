import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/router_observer.dart';
import 'package:gyeonggi_express/ui/component/bottom_navigation_bar.dart';
import 'package:gyeonggi_express/ui/home/home_screen.dart';
import 'package:gyeonggi_express/ui/login/login_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_setting_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_screen.dart';
import 'package:gyeonggi_express/ui/splash/splash_screen.dart';

enum Routes {
  splash,
  login,
  home,
  recommend,
  photobook,
  mypage,
  mypage_setting;

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
      ),

      // 탭 루트 화면들
      ShellRoute(
        observers: [RouterObserver()],
        builder: (context, state, child) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(child: child),
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
        ),
        routes: [
          GoRoute(
            path: '/home',
            name: Routes.home.name,
            builder: (context, state) => const HomeScreen()
          ),
          GoRoute(
            path: '/recommend',
            name: Routes.recommend.name,
            builder: (context, state) => const RecommendScreen()
          ),
          GoRoute(
            path: '/photobook',
            name: Routes.photobook.name,
            builder: (context, state) => const PhotobookScreen()
          ),
          GoRoute(
            path: '/mypage',
            name: Routes.mypage.name,
            builder: (context, state) => const MyPageScreen()
          )
        ]
      ),

      GoRoute(
        path: '/mypage/setting',
        name: Routes.mypage_setting.name,
        builder: (context, state) => const MyPageSettingScreen()
      )
    ]
  );
}
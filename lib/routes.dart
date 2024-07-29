import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/router_observer.dart';
import 'package:gyeonggi_express/ui/component/app/app_bottom_navigation_bar.dart';
import 'package:gyeonggi_express/ui/home/home_screen.dart';
import 'package:gyeonggi_express/ui/login/login_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_policy_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_setting_screen.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_complete_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_screen.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_screen.dart';
import 'package:gyeonggi_express/ui/splash/splash_screen.dart';
import 'package:gyeonggi_express/ui/station/station_detail_screen.dart';

import 'data/models/login_provider.dart';

enum Routes {
  splash,
  login,
  onboarding,
  onboarding_complete,

  home,

  stations,

  recommend,
  photobook,

  mypage,
  mypage_setting,
  mypage_service_policy,
  mypage_privacy_policy;

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
          backgroundColor: Colors.white, body: SafeArea(child: child)
        ),
        routes: [
          GoRoute(
            path: '/login',
            name: Routes.login.name,
            builder: (context, state) => const LoginScreen()
          ),
          GoRoute(
            path: "/onboarding",
            name: Routes.onboarding.name,
            builder: (context, state) => const OnboardingScreen()
          ),
          GoRoute(
            path: '/onboarding/complete',
            name: Routes.onboarding_complete.name,
            builder: (context, state) => const OnboardingCompleteScreen(),
          )
        ]
      ),

      ShellRoute(
        observers: [RouterObserver()],
        builder: (context, state, child) => Scaffold(
          backgroundColor: Colors.white,
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
            builder: (context, state) => PhotobookScreen()),
          GoRoute(
            path: '/mypage',
            name: Routes.mypage.name,
            builder: (context, state) => const MyPageScreen()
          )
        ]
      ),

      GoRoute(
        path: '/stations',
        name: Routes.stations.name,
        builder: (context, state) => const StationDetailScreen()
      ),
      GoRoute(
        path: '/mypage/setting',
        name: Routes.mypage_setting.name,
        builder: (context, state) => MyPageSettingScreen(
          nickname: state.uri.queryParameters['nickname'] ?? "",
          email: state.uri.queryParameters['email'] ?? "",
          loginType: LoginProvider.fromJson(state.uri.queryParameters['loginType'] ?? ""),
        )
      ),
      GoRoute(
        path: '/mypage/policy/service',
        name: Routes.mypage_service_policy.name,
        builder: (context, state) => MyPagePolicyScreen(
          title: state.uri.queryParameters['title'] ?? "",
          url: state.uri.queryParameters['url'] ?? "",
        ),
      ),

      GoRoute(
        path: '/mypage/policy/privacy',
        name: Routes.mypage_privacy_policy.name,
        builder: (context, state) => MyPagePolicyScreen(
          title: state.uri.queryParameters['title'] ?? "",
          url: state.uri.queryParameters['url'] ?? "",
        ),
      ),
    ]
  );
}

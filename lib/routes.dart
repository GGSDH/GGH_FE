import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/router_observer.dart';
import 'package:gyeonggi_express/ui/categoryexplorer/category_explorer_screen.dart';
import 'package:gyeonggi_express/ui/component/app/app_bottom_navigation_bar.dart';
import 'package:gyeonggi_express/ui/home/home_screen.dart';
import 'package:gyeonggi_express/ui/lane/lane_detail_screen.dart';
import 'package:gyeonggi_express/ui/login/login_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_policy_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_setting_screen.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_complete_screen.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_loading_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_select_period_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_select_theme_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_screen.dart';
import 'package:gyeonggi_express/ui/splash/splash_screen.dart';
import 'package:gyeonggi_express/ui/station/station_detail_screen.dart';

import 'data/models/login_provider.dart';

enum Routes {
  splash,
  login,
  onboarding,
  onboarding_complete,

  home,

  category_explorer,

  stations,
  lanes,

  recommend,
  photobook,

  add_photobook,
  add_photobook_select_period,
  add_photobook_select_theme,
  add_photobook_loading,

  mypage,
  mypage_setting,
  mypage_service_policy,
  mypage_privacy_policy;

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter config = GoRouter(
      initialLocation: '/categoryexplorer/전체',
      observers: [RouterObserver()],
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
            path: '/',
            name: Routes.splash.name,
            builder: (context, state) => const SplashScreen()),
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
                  path: "/onboarding",
                  name: Routes.onboarding.name,
                  builder: (context, state) => const OnboardingScreen()),
              GoRoute(
                path: '/onboarding/complete',
                name: Routes.onboarding_complete.name,
                builder: (context, state) => const OnboardingCompleteScreen(),
              )
            ]),
        StatefulShellRoute.indexedStack(
            builder: (context, state, child) => Scaffold(
              backgroundColor: Colors.white,
              body: child,
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: child.currentIndex,
                onTap: (index) {
                  child.goBranch(index);
                }
              ),
            ),
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                    path: '/home',
                    name: Routes.home.name,
                    builder: (context, state) => const HomeScreen(),
                    routes: const []),
              ]),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: '/recommend',
                      name: Routes.recommend.name,
                      builder: (context, state) => const RecommendScreen(),
                      routes: const []),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: '/photobook',
                      name: Routes.photobook.name,
                      builder: (context, state) => Scaffold(
                        body: PhotobookScreen()
                      ),
                      routes: [
                        GoRoute(
                            path: 'add',
                            name: Routes.add_photobook.name,
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) =>
                                const AddPhotobookScreen()),
                        GoRoute(
                            path: 'add/select-period',
                            name: Routes.add_photobook_select_period.name,
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) =>
                                const AddPhotobookSelectPeriodScreen()),
                        GoRoute(
                            path: 'add/select-theme',
                            name: Routes.add_photobook_select_theme.name,
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) =>
                                const AddPhotobookSelectThemeScreen()),
                        GoRoute(
                            path: 'add/loading',
                            name: Routes.add_photobook_loading.name,
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) =>
                                const AddPhotobookLoadingScreen()),
                      ]),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: '/mypage',
                      name: Routes.mypage.name,
                      builder: (context, state) => const MyPageScreen(),
                      routes: [
                        GoRoute(
                            path: 'setting',
                            name: Routes.mypage_setting.name,
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) => MyPageSettingScreen(
                                  nickname:
                                      state.uri.queryParameters['nickname'] ??
                                          "",
                                  email:
                                      state.uri.queryParameters['email'] ?? "",
                                  loginType: LoginProvider.fromJson(
                                      state.uri.queryParameters['loginType'] ??
                                          ""),
                                )),
                        GoRoute(
                          path: 'policy/service',
                          name: Routes.mypage_service_policy.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) => MyPagePolicyScreen(
                            title: state.uri.queryParameters['title'] ?? "",
                            url: state.uri.queryParameters['url'] ?? "",
                          ),
                        ),
                        GoRoute(
                          path: 'policy/privacy',
                          name: Routes.mypage_privacy_policy.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) => MyPagePolicyScreen(
                            title: state.uri.queryParameters['title'] ?? "",
                            url: state.uri.queryParameters['url'] ?? "",
                          ),
                        ),
                      ]),
                ],
              ),
            ]),
        GoRoute(
            path: '/stations',
            name: Routes.stations.name,
            builder: (context, state) => StationDetailScreen()),
        GoRoute(
            path: '/lanes',
            name: Routes.lanes.name,
            builder: (context, state) => LaneDetailScreen()),
        GoRoute(
          path: '/categoryexplorer/:categoryName',
          name: Routes.category_explorer.name,
          builder: (context, state) => CategoryExplorerScreen(
            categoryName: state.pathParameters['categoryName'] ?? '',
          ),
        ),
      ]);
}

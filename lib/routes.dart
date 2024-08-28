import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/router_observer.dart';
import 'package:gyeonggi_express/ui/favorite/favorite_screen.dart';
import 'package:gyeonggi_express/ui/home/category_detail_bloc.dart';
import 'package:gyeonggi_express/ui/home/category_detail_screen.dart';
import 'package:gyeonggi_express/ui/component/app/app_bottom_navigation_bar.dart';
import 'package:gyeonggi_express/ui/home/home_screen.dart';
import 'package:gyeonggi_express/ui/home/local_restaruant_bloc.dart';
import 'package:gyeonggi_express/ui/home/local_restaurant_screen.dart';
import 'package:gyeonggi_express/ui/home/popular_destination_bloc.dart';
import 'package:gyeonggi_express/ui/home/popular_destination_screen.dart';
import 'package:gyeonggi_express/ui/home/recommended_lane_screen.dart';
import 'package:gyeonggi_express/ui/home/area_filter_screen.dart';
import 'package:gyeonggi_express/ui/lane/lane_detail_screen.dart';
import 'package:gyeonggi_express/ui/login/login_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_policy_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_setting_screen.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_complete_screen.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_loading_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_select_period_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_bloc.dart';
import 'package:gyeonggi_express/ui/photobook/phototicket/add_photo_ticket_bloc.dart';
import 'package:gyeonggi_express/ui/photobook/phototicket/select_photo_ticket_bloc.dart';
import 'package:gyeonggi_express/ui/photobook/phototicket/add_photo_ticket_screen.dart';
import 'package:gyeonggi_express/ui/photobook/phototicket/select_photo_ticket_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_card_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_image_list_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_map_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_result_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_select_period_screen.dart';
import 'package:gyeonggi_express/ui/search/search_screen.dart';
import 'package:gyeonggi_express/ui/splash/splash_screen.dart';
import 'package:gyeonggi_express/ui/station/station_detail_screen.dart';

import 'data/models/login_provider.dart';
import 'data/models/sigungu_code.dart';
import 'data/models/trip_theme.dart';
import 'data/repository/trip_repository.dart';

enum Routes {
  splash,
  login,

  onboarding,
  onboardingComplete,

  home,
  popularDestinations,
  recommendedLanes,
  localRestaurants,
  categoryDetail,
  areaFilter,

  stations,
  lanes,

  search,

  favorites,

  recommend,
  recommendSelectPeriod,
  recommendResult,

  photobook,
  photobookCard,
  photobookDetail,
  photobookMap,
  photobookImageList,
  photobookImageDetail,

  addPhotobook,
  addPhotobookSelectPeriod,
  addPhotobookLoading,

  selectPhotoTicket,
  addPhotoTicket,

  myPage,
  myPageSetting,
  myPageServicePolicy,
  myPagePrivacyPolicy;

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter config = GoRouter(
      initialLocation: Routes.splash.path,
      observers: [RouterObserver()],
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
            path: Routes.splash.path,
            name: Routes.splash.name,
            builder: (context, state) => const SplashScreen()),
        ShellRoute(
            observers: [RouterObserver()],
            builder: (context, state, child) => Scaffold(
                backgroundColor: Colors.white, body: SafeArea(child: child)),
            routes: [
              GoRoute(
                  path: Routes.login.path,
                  name: Routes.login.name,
                  builder: (context, state) => const LoginScreen()),
              GoRoute(
                  path: Routes.onboarding.path,
                  name: Routes.onboarding.name,
                  builder: (context, state) => const OnboardingScreen()),
              GoRoute(
                path: Routes.onboardingComplete.path,
                name: Routes.onboardingComplete.name,
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
                      }),
                ),
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                    path: Routes.home.path,
                    name: Routes.home.name,
                    builder: (context, state) => const HomeScreen(),
                    routes: [
                      GoRoute(
                        path: Routes.popularDestinations.path,
                        name: Routes.popularDestinations.name,
                        builder: (context, state) => BlocProvider(
                            create: (context) => PopularDestinationBloc(
                                  tripRepository:
                                      GetIt.instance<TripRepository>(),
                                )..add(PopularDestinationFetched()),
                            child: const PopularDestinationScreen()),
                      ),
                      GoRoute(
                        path: Routes.recommendedLanes.path,
                        name: Routes.recommendedLanes.name,
                        builder: (context, state) =>
                            const RecommendedLaneScreen(),
                      ),
                      GoRoute(
                          path: Routes.localRestaurants.path,
                          name: Routes.localRestaurants.name,
                          builder: (context, state) => BlocProvider(
                                create: (context) => LocalRestaurantBloc(
                                  tripRepository:
                                      GetIt.instance<TripRepository>(),
                                )..add(LocalRestaurantFetched()),
                                child: const LocalRestaurantScreen(),
                              )),
                      GoRoute(
                          path: Routes.categoryDetail.path,
                          name: Routes.categoryDetail.name,
                          builder: (context, state) {
                            final theme =
                                state.uri.queryParameters['category'] ??
                                    TripTheme.NATURAL.name;
                            final category = TripTheme.fromJson(theme);

                            return BlocProvider(
                              create: (context) => CategoryDetailBloc(
                                tripRepository:
                                    GetIt.instance<TripRepository>(),
                              ),
                              child: CategoryDetailScreen(category: category),
                            );
                          }),
                    ]),
              ]),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: Routes.recommend.path,
                      name: Routes.recommend.name,
                      builder: (context, state) => const RecommendScreen(),
                      routes: [
                        GoRoute(
                          path: Routes.recommendSelectPeriod.path,
                          name: Routes.recommendSelectPeriod.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) =>
                              const RecommendSelectPeriodScreen(),
                        ),
                        GoRoute(
                          path: Routes.recommendResult.path,
                          name: Routes.recommendResult.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) => RecommendResultScreen(),
                        )
                      ]),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.photobook.path,
                    name: Routes.photobook.name,
                    builder: (context, state) => BlocProvider(
                      create: (context) => PhotobookBloc(
                        photobookRepository: GetIt.instance<PhotobookRepository>(),
                      )..add(FetchPhotobooks())..add(FetchPhotoTickets()),
                      child: const Scaffold(body: PhotobookScreen())
                    ),
                    routes: [
                      GoRoute(
                        path: Routes.addPhotobook.path,
                        name: Routes.addPhotobook.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => const AddPhotobookScreen(),
                        routes: [
                          GoRoute(
                              path: Routes.addPhotobookSelectPeriod.path,
                              name: Routes.addPhotobookSelectPeriod.name,
                              parentNavigatorKey: _rootNavigatorKey,
                              builder: (context, state) =>
                                  const AddPhotobookSelectPeriodScreen()),
                          GoRoute(
                              path: Routes.addPhotobookLoading.path,
                              name: Routes.addPhotobookLoading.name,
                              parentNavigatorKey: _rootNavigatorKey,
                              builder: (context, state) {
                                final startDate =
                                    state.uri.queryParameters['startDate'] ??
                                        '';
                                final endDate =
                                    state.uri.queryParameters['endDate'] ?? '';
                                final title =
                                    state.uri.queryParameters['title'] ?? '';

                                return AddPhotobookLoadingScreen(
                                  startDate: startDate,
                                  endDate: endDate,
                                  title: title,
                                );
                              }),
                        ],
                      ),
                      GoRoute(
                          path: Routes.selectPhotoTicket.path,
                          name: Routes.selectPhotoTicket.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) {
                            return BlocProvider(
                                create: (context) => SelectPhotoTicketBloc(
                                      photobookRepository:
                                          GetIt.instance<PhotobookRepository>(),
                                    )..add(SelectPhotoTicketInitialize()),
                                child: const SelectPhotoTicketScreen());
                          },
                          routes: [
                            GoRoute(
                              path: Routes.addPhotoTicket.path,
                              name: Routes.addPhotoTicket.name,
                              parentNavigatorKey: _rootNavigatorKey,
                              builder: (context, state) {
                                final title =
                                    state.uri.queryParameters['title'] ?? '';
                                final startDate =
                                    state.uri.queryParameters['startDate'] ??
                                        '';
                                final endDate =
                                    state.uri.queryParameters['endDate'] ?? '';
                                final location =
                                    state.uri.queryParameters['location'] ?? '';
                                final selectedPhotoPath =
                                    state.uri.queryParameters['selectedPhotoPath'] ?? '';
                                final selectedPhotoId =
                                    state.uri.queryParameters['selectedPhotoId'] ?? '';

                                return BlocProvider(
                                  create: (context) => AddPhotoTicketBloc(
                                    photobookRepository:
                                        GetIt.instance<PhotobookRepository>(),
                                  )..add(AddPhotoTicketInitialize(
                                      title,
                                      startDate,
                                      endDate,
                                      location,
                                      selectedPhotoPath,
                                      selectedPhotoId,
                                    )
                                  ),
                                  child: const AddPhotoTicketScreen(),
                                );
                              },
                            )
                          ]
                      ),
                      GoRoute(
                          path: Routes.photobookCard.path,
                          name: Routes.photobookCard.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) => PhotobookCardScreen(
                                photobookId:
                                    state.uri.queryParameters['photobookId'] ??
                                        '',
                              )),
                      GoRoute(
                          path: Routes.photobookDetail.path,
                          name: Routes.photobookDetail.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) => PhotobookDetailScreen(
                                photobookId:
                                    state.uri.queryParameters['photobookId'] ??
                                        '',
                                selectedDay:
                                    state.uri.queryParameters['selectedDay'] ??
                                        '1',
                              )),
                      GoRoute(
                          path: Routes.photobookMap.path,
                          name: Routes.photobookMap.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) => PhotobookMapScreen(
                                photobookId:
                                    state.uri.queryParameters['photobookId'] ??
                                        '',
                              )),
                      GoRoute(
                        path: Routes.photobookImageList.path,
                        name: Routes.photobookImageList.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final filePathsQuery =
                              state.uri.queryParameters['filePaths'];
                          final List<String> filePaths = (filePathsQuery !=
                                      null &&
                                  filePathsQuery.isNotEmpty)
                              ? filePathsQuery
                                  .split(',')
                                  .where((path) => path
                                      .isNotEmpty) // Filter out any empty strings
                                  .toList()
                              : [];

                          return PhotobookImageListScreen(filePaths: filePaths);
                        },
                      ),
                    ],
                  )
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                      path: Routes.myPage.path,
                      name: Routes.myPage.name,
                      builder: (context, state) => const MyPageScreen(),
                      routes: [
                        GoRoute(
                            path: Routes.myPageSetting.path,
                            name: Routes.myPageSetting.name,
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
                          path: Routes.myPageServicePolicy.path,
                          name: Routes.myPageServicePolicy.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) => MyPagePolicyScreen(
                            title: state.uri.queryParameters['title'] ?? "",
                            url: state.uri.queryParameters['url'] ?? "",
                          ),
                        ),
                        GoRoute(
                          path: Routes.myPagePrivacyPolicy.path,
                          name: Routes.myPagePrivacyPolicy.name,
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
            path: '${Routes.stations.path}/:stationId',
            name: Routes.stations.name,
            builder: (context, state) {
              final stationId =
                  int.tryParse(state.pathParameters['stationId'] ?? '');
              if (stationId == null) {
                return const Text('Invalid station ID');
              }
              return StationDetailScreen(stationId: stationId);
            }),
        GoRoute(
            path: '${Routes.lanes.path}/:laneId',
            name: Routes.lanes.name,
            builder: (context, state) {
              final laneId = int.tryParse(state.pathParameters['laneId'] ?? '');
              if (laneId == null) {
                return const Text('Invalid lane ID');
              }
              return LaneDetailScreen(laneId: laneId);
            }),
        GoRoute(
          path: Routes.search.path,
          name: Routes.search.name,
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: Routes.favorites.path,
          name: Routes.favorites.name,
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
            path: Routes.areaFilter.path,
            name: Routes.areaFilter.name,
            builder: (context, state) {
              final selectedAreasQuery =
                  state.uri.queryParameters['selectedAreas'];
              final List<SigunguCode> selectedAreas =
                  (selectedAreasQuery != null && selectedAreasQuery.isNotEmpty)
                      ? selectedAreasQuery
                          .split(',')
                          .where((e) =>
                              e.isNotEmpty) // Filter out any empty strings
                          .map((e) {
                          try {
                            return SigunguCode.fromJson(e);
                          } catch (e) {
                            return SigunguCode.UNKNOWN;
                          }
                        }).toList()
                      : [];

              return AreaFilterScreen(initialSelectedAreas: selectedAreas);
            })
      ]);
}

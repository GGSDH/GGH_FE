import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/repository/lane_repository.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/router_observer.dart';
import 'package:gyeonggi_express/ui/component/app/app_bottom_navigation_bar.dart';
import 'package:gyeonggi_express/ui/component/web_view_screen.dart';
import 'package:gyeonggi_express/ui/favorite/favorite_bloc.dart';
import 'package:gyeonggi_express/ui/favorite/favorite_screen.dart';
import 'package:gyeonggi_express/ui/home/area_filter_screen.dart';
import 'package:gyeonggi_express/ui/home/category_detail_bloc.dart';
import 'package:gyeonggi_express/ui/home/category_detail_screen.dart';
import 'package:gyeonggi_express/ui/home/home_screen.dart';
import 'package:gyeonggi_express/ui/home/local_restaruant_bloc.dart';
import 'package:gyeonggi_express/ui/home/local_restaurant_screen.dart';
import 'package:gyeonggi_express/ui/home/popular_destination_bloc.dart';
import 'package:gyeonggi_express/ui/home/popular_destination_screen.dart';
import 'package:gyeonggi_express/ui/home/recommended_lane_bloc.dart';
import 'package:gyeonggi_express/ui/home/recommended_lane_screen.dart';
import 'package:gyeonggi_express/ui/lane/lane_detail_bloc.dart';
import 'package:gyeonggi_express/ui/lane/lane_detail_screen.dart';
import 'package:gyeonggi_express/ui/login/login_bloc.dart';
import 'package:gyeonggi_express/ui/login/login_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_bloc.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_screen.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_setting_bloc.dart';
import 'package:gyeonggi_express/ui/mypage/mypage_setting_screen.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_bloc.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_complete_screen.dart';
import 'package:gyeonggi_express/ui/onboarding/onboarding_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_bloc.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_loading_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_screen.dart';
import 'package:gyeonggi_express/ui/photobook/add/add_photobook_select_period_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_bloc.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_card_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_bloc.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_image_list_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_map_screen.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_screen.dart';
import 'package:gyeonggi_express/ui/photobook/phototicket/add_photo_ticket_bloc.dart';
import 'package:gyeonggi_express/ui/photobook/phototicket/add_photo_ticket_screen.dart';
import 'package:gyeonggi_express/ui/photobook/phototicket/select_photo_ticket_bloc.dart';
import 'package:gyeonggi_express/ui/photobook/phototicket/select_photo_ticket_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_lane_bloc.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_result_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_select_period_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_select_region_screen.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_select_theme_screen.dart';
import 'package:gyeonggi_express/ui/search/search_bloc.dart';
import 'package:gyeonggi_express/ui/search/search_screen.dart';
import 'package:gyeonggi_express/ui/splash/splash_bloc.dart';
import 'package:gyeonggi_express/ui/splash/splash_screen.dart';
import 'package:gyeonggi_express/ui/station/station_detail_bloc.dart';
import 'package:gyeonggi_express/ui/station/station_detail_screen.dart';

import 'data/models/login_provider.dart';
import 'data/models/sigungu_code.dart';
import 'data/models/trip_theme.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/favorite_repository.dart';
import 'data/repository/search_repository.dart';
import 'data/repository/tour_area_repository.dart';
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

  webView,

  search,

  favorites,

  recommend,
  recommendSelectRegion,
  recommendSelectPeriod,
  recommendSelectTheme,
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
  myPageSetting;

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
            builder: (context, state) => BlocProvider(
                create: (context) => SplashBloc(
                  authRepository: GetIt.instance<AuthRepository>(),
                  storage: GetIt.instance<FlutterSecureStorage>(),
                ),
                child: const SplashScreen()
            )
        ),
        ShellRoute(
            observers: [RouterObserver()],
            builder: (context, state, child) => Scaffold(
                backgroundColor: Colors.white, body: SafeArea(child: child)),
            routes: [
              GoRoute(
                  path: Routes.login.path,
                  name: Routes.login.name,
                  builder: (context, state) => BlocProvider(
                      create: (context) => LoginBloc(
                        authRepository: GetIt.instance<AuthRepository>(),
                        secureStorage: GetIt.instance<FlutterSecureStorage>(),
                      ),
                      child: const LoginScreen()
                  )
              ),
              GoRoute(
                  path: Routes.onboarding.path,
                  name: Routes.onboarding.name,
                  builder: (context, state) => BlocProvider(
                    create: (context) => OnboardingBloc(
                      authRepository: GetIt.instance.get<AuthRepository>(),
                      secureStorage: GetIt.instance.get<FlutterSecureStorage>(),
                    ),
                    child: const OnboardingScreen()
                  ),
              ),
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
                  switch (index) {
                    case 0:
                      GoRouter.of(context).go(Routes.home.path); // 첫 번째 branch로 이동
                      break;
                    case 1:
                      GoRouter.of(context).go(Routes.recommend.path); // 두 번째 branch로 이동
                      break;
                    case 2:
                      GoRouter.of(context).go(Routes.photobook.path); // 세 번째 branch로 이동
                      break;
                    case 3:
                      GoRouter.of(context).go(Routes.myPage.path); // 네 번째 branch로 이동
                      break;
                  }
                },
              ),
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
                        builder: (context, state) => BlocProvider(
                            create: (context) => RecommendedLaneBloc(
                              tripRepository: GetIt.instance<TripRepository>(),
                              favoriteRepository: GetIt.instance<FavoriteRepository>(),
                            )..add(RecommendedLaneInitialize()),
                            child: const RecommendedLaneScreen()
                        ),
                      ),
                      GoRoute(
                          path: Routes.localRestaurants.path,
                          name: Routes.localRestaurants.name,
                          builder: (context, state) => BlocProvider(
                                create: (context) => LocalRestaurantBloc(
                                  tripRepository:
                                    GetIt.instance<TripRepository>(),
                                  favoriteRepository:
                                    GetIt.instance<FavoriteRepository>()
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
                                favoriteRepository:
                                    GetIt.instance<FavoriteRepository>(),
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
                      // BlocProvider를 상위에서 제공하여 하위 라우트들에 동일한 Bloc을 공유합니다.
                      GoRoute(
                          path: Routes.recommendSelectRegion.path,
                          name: Routes.recommendSelectRegion.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) =>
                              const RecommendSelectRegionScreen()),
                      GoRoute(
                        path: Routes.recommendSelectPeriod.path,
                        name: Routes.recommendSelectPeriod.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            RecommendSelectPeriodScreen(
                                sigunguCodes: state.uri
                                        .queryParameters['selectedSigunguCodes']
                                        ?.split(',')
                                        .map((e) => SigunguCode.fromJson(e))
                                        .toList() ??
                                    []),
                      ),
                      GoRoute(
                        path: Routes.recommendSelectTheme.path,
                        name: Routes.recommendSelectTheme.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => RecommendSelectThemeScreen(
                            sigunguCodes: state
                                    .uri.queryParameters['selectedSigunguCodes']
                                    ?.split(',')
                                    .map((e) => SigunguCode.fromJson(e))
                                    .toList() ??
                                [],
                            days: int.tryParse(
                                    state.uri.queryParameters['selectedDays'] ??
                                        '') ??
                                1),
                      ),
                      GoRoute(
                          path: Routes.recommendResult.path,
                          name: Routes.recommendResult.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) {
                            // Bloc 생성
                            final bloc = RecommendLaneBloc(
                              tripRepository: GetIt.instance<TripRepository>(),
                              favoriteRepository:
                                  GetIt.instance<FavoriteRepository>(),
                            );

                            final selectedSigunguCodes = state
                                    .uri.queryParameters['selectedSigunguCodes']
                                    ?.split(',')
                                    .map((e) => SigunguCode.fromJson(e))
                                    .toList() ??
                                [];

                            final selectedDays = int.tryParse(
                                    state.uri.queryParameters['selectedDays'] ??
                                        '') ?? 1;

                            final selectedTripThemes = state.uri
                                    .queryParameters['selectedTripThemes']
                                    ?.split(',')
                                    .map((e) => TripTheme.fromJson(e))
                                    .toList() ??
                                [];

                            // 이벤트 추가
                            bloc.add(
                              RecommendLaneInitialize(
                                  selectedSigunguCodes: selectedSigunguCodes,
                                  selectedDays: selectedDays,
                                  selectedTripThemes: selectedTripThemes),
                            );

                            return BlocProvider(
                              create: (context) => bloc,
                              child: RecommendResultScreen(
                                sigunguCodes: selectedSigunguCodes,
                                days: selectedDays,
                                tripThemes: selectedTripThemes,
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.photobook.path,
                    name: Routes.photobook.name,
                    builder: (context, state) => BlocProvider(
                        create: (context) => PhotobookBloc(
                              photobookRepository:
                                  GetIt.instance<PhotobookRepository>(),
                            )
                              ..add(FetchPhotobooks())
                              ..add(FetchPhotoTickets()),
                        child: const Scaffold(body: PhotobookScreen())),
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

                                return BlocProvider(
                                    create: (context) => AddPhotobookBloc(
                                    photobookRepository: GetIt.instance<PhotobookRepository>(),
                                  )..add(
                                    AddPhotobookUpload(
                                      title: title,
                                      startDate: DateTime.parse(startDate),
                                      endDate: DateTime.parse(endDate),
                                    ),
                                  ),
                                  child: const AddPhotobookLoadingScreen()
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
                                final selectedPhotoPath = state.uri
                                        .queryParameters['selectedPhotoPath'] ??
                                    '';
                                final selectedPhotoId = state.uri
                                        .queryParameters['selectedPhotoId'] ??
                                    '';

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
                                    )),
                                  child: const AddPhotoTicketScreen(),
                                );
                              },
                            )
                          ]),
                      GoRoute(
                          path: Routes.photobookCard.path,
                          name: Routes.photobookCard.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) {
                            final photobookId = state.uri.queryParameters['photobookId'] ?? '';
                            return BlocProvider(
                                create: (context) => PhotobookDetailBloc(
                                  photobookRepository: GetIt.instance<PhotobookRepository>(),
                                )..add(PhotobookDetailInitialize(int.parse(photobookId))),
                                child:PhotobookCardScreen(
                                photobookId:
                                    state.uri.queryParameters['photobookId'] ??
                                        '',
                              )
                            );
                          }
                      ),
                      GoRoute(
                          path: Routes.photobookDetail.path,
                          name: Routes.photobookDetail.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) {
                            final photobookId = state.uri.queryParameters['photobookId'] ?? '';
                            final selectedDay = state.uri.queryParameters['selectedDay'] ?? '1';

                            return BlocProvider(
                                create: (context) => PhotobookDetailBloc(
                                  photobookRepository: GetIt.instance<PhotobookRepository>(),
                                )..add(PhotobookDetailInitialize(int.parse(photobookId))),
                                child: PhotobookDetailScreen(
                                photobookId: photobookId,
                                selectedDay: selectedDay,
                              )
                            );
                          }
                      ),
                      GoRoute(
                          path: Routes.photobookMap.path,
                          name: Routes.photobookMap.name,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) => BlocProvider(
                            create: (context) => PhotobookDetailBloc(
                              photobookRepository: GetIt.instance<PhotobookRepository>(),
                            )..add(PhotobookDetailInitialize(int.parse(state.uri.queryParameters['photobookId'] ?? ''))),
                            child: const PhotobookMapScreen()
                          )
                      ),
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
                      builder: (context, state) => BlocProvider(
                        create: (context) => MyPageBloc(
                          authRepository: GetIt.instance<AuthRepository>(),
                          secureStorage: GetIt.instance<FlutterSecureStorage>(),
                        ),
                        child: const MyPageScreen()
                      ),
                      routes: [
                        GoRoute(
                            path: Routes.myPageSetting.path,
                            name: Routes.myPageSetting.name,
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) {
                              final nickname = state.uri.queryParameters['nickname'] ?? '';
                              final loginType = LoginProvider.fromJson(state.uri.queryParameters['loginType'] ?? "");

                              return BlocProvider(
                                create: (context) =>
                                MyPageSettingBloc(
                                  authRepository: GetIt.instance<
                                      AuthRepository>(),
                                )
                                  ..add(MyPageSettingInitialize(
                                    nickname: nickname, loginType: loginType)
                                  ),
                                child: MyPageSettingScreen(
                                  nickname: nickname, loginType: loginType),
                              );
                            }
                        )
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
              return BlocProvider(
                  create: (context) => StationDetailBloc(
                        tourAreaRepository:
                            GetIt.instance<TourAreaRepository>(),
                        favoriteRepository:
                            GetIt.instance<FavoriteRepository>(),
                      )..add(InitializeStationDetail(stationId)),
                  child: StationDetailScreen(stationId: stationId));
            }),
        GoRoute(
            path: '${Routes.lanes.path}/:laneId',
            name: Routes.lanes.name,
            builder: (context, state) {
              final laneId = int.tryParse(state.pathParameters['laneId'] ?? '');
              if (laneId == null) {
                return const Text('Invalid lane ID');
              }
              return BlocProvider(
                create: (context) => LaneDetailBloc(
                  laneRepository: GetIt.instance<LaneRepository>(),
                  favoriteRepository: GetIt.instance<FavoriteRepository>(),
                )..add(LaneDetailInitialize(laneId: laneId)),
                child: LaneDetailScreen(laneId: laneId)
              );
            }),
        GoRoute(
          path: Routes.webView.path,
          name: Routes.webView.name,
          builder: (context, state) => WebViewScreen(
            title: state.uri.queryParameters['title'] ?? "",
            url: state.uri.queryParameters['url'] ?? "",
          ),
        ),
        GoRoute(
          path: Routes.search.path,
          name: Routes.search.name,
          builder: (context, state) => BlocProvider(
            create: (context) => SearchBloc(GetIt.instance<SearchRepository>())..add(FetchPopularKeywords()),
            child: const SearchScreen(),
          )
        ),
        GoRoute(
          path: Routes.favorites.path,
          name: Routes.favorites.name,
          builder: (context, state) => BlocProvider(
            create: (context) =>
              FavoritesBloc(repository: GetIt.instance<FavoriteRepository>())..add(LoadFavorites()),
            child: const FavoritesScreen()
          )
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

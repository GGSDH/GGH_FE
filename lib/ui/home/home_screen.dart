import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/destination/popular_destination_list_item.dart';
import 'package:gyeonggi_express/ui/component/lane/lane_list_item.dart';
import 'package:gyeonggi_express/ui/component/restaurant/restaurant_list_item.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/lane_response.dart';
import '../../data/models/response/local_restaurant_response.dart';
import '../../data/models/trip_theme.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/trip_repository.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import 'home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        authRepository: GetIt.instance<AuthRepository>(),
        tripRepository: GetIt.instance<TripRepository>(),
        favoriteRepository: GetIt.instance<FavoriteRepository>(),
      )..add(
          HomeInitialize(),
        ),
      child: BlocSideEffectListener<HomeBloc, HomeSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is HomeShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(sideEffect.message),
              ),
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBanner(context),
                  _buildCategories(
                    (category) {
                      GoRouter.of(context).push(Uri(
                        path:
                            "${Routes.home.path}/${Routes.categoryDetail.path}",
                        queryParameters: {
                          'category': TripTheme.toJson(category)
                        },
                      ).toString());
                    },
                  ),
                  _buildRecommendBody(
                      context: context,
                      userName: state.userName,
                      lanes: state.lanes,
                      onShowMore: () {
                        GoRouter.of(context).push(
                            "${Routes.home.path}/${Routes.recommendedLanes.path}");
                      },
                      onItemClick: (p0) => {
                            GoRouter.of(context)
                                .push('${Routes.lanes.path}/$p0')
                          }),
                  _buildRestaurantBody(
                    context: context,
                    localRestaurants: state.localRestaurants,
                    onShowMore: () {
                      GoRouter.of(context).push(
                          "${Routes.home.path}/${Routes.localRestaurants.path}");
                    },
                    onItemClick: (p0) => {
                      GoRouter.of(context).push('${Routes.stations.path}/$p0')
                    },
                  ),
                  _buildPopularPlaceBody(
                    popularDestinations: state.popularDestinations,
                    onShowMore: () {
                      GoRouter.of(context).push(
                          "${Routes.home.path}/${Routes.popularDestinations.path}");
                    },
                    onItemClick: (p0) => {
                      GoRouter.of(context).push('${Routes.stations.path}/$p0')
                    },
                  )
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 44, 0, 0),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/ic_app_title.svg',
                    width: 57, height: 24),
                Row(
                  children: [
                    _buildIconButton(
                      "assets/icons/ic_heart_white.svg",
                      () {
                        context.push(Routes.favorites.path);
                      },
                    ),
                    const SizedBox(width: 14),
                    _buildIconButton(
                      "assets/icons/ic_search_white.svg",
                      () {
                        context.push(Routes.search.path);
                      },
                    ),
                  ],
                )
              ])),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: 394,
        color: ColorStyles.gray800,
      ),
      Container(
        width: double.infinity,
        height: 394,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(1.0),
              ]),
        ),
      ),
      const SizedBox(height: 133),
      Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            const SizedBox(height: 35),
            const Text(
              "나만의 노선으로\n떠나는 여행",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "지금 떠나보세요!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
      Positioned(
        right: 0,
        top: 152,
        child: SvgPicture.asset("assets/icons/ic_home_illust.svg",
            width: 205, height: 166),
      )
    ]);
  }

  Widget _buildIconButton(String assetPath, VoidCallback onTap,
      {double width = 24, double height = 24}) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
      ),
    );
  }

  Widget _buildCategories(Function(TripTheme category) onTapCategory) {
    const categories = TripTheme.values;

    return SizedBox(
      height: 120,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          for (final category in categories) ...[
            _buildCategoryItem(category, () {
              onTapCategory(category);
            }),
            const SizedBox(width: 8)
          ]
        ],
      ),
    );
  }

  Widget _buildCategoryItem(TripTheme category, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            category.icon,
            style: const TextStyle(fontSize: 36),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 60,
            child: Text(
              category.title,
              style: TextStyles.titleSmall.copyWith(
                color: ColorStyles.gray800,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecommendBody({
    required BuildContext context,
    required String userName,
    required List<Lane> lanes,
    required VoidCallback onShowMore,
    required Function(int) onItemClick,
  }) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "$userName님",
                      style: TextStyles.titleExtraLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: "이\n좋아하실만한 노선",
                          style: TextStyles.titleExtraLarge,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onShowMore,
                    child: Row(
                      children: [
                        Text(
                          "더보기",
                          style: TextStyles.bodyMedium.copyWith(
                            color: ColorStyles.gray500,
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/ic_arrow_right.svg",
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            for (final lane in lanes) ...[
              GestureDetector(
                onTap: () => onItemClick(lane.laneId),
                child: _buildRecommendItem(
                  context: context,
                  laneId: lane.laneId,
                  category: lane.category.title,
                  title: lane.laneName,
                  description: '',
                  image: lane.image,
                  period: lane.getPeriodString(),
                  likeCount: lane.likeCount,
                  isLiked: lane.likedByMe,
                ),
              ),
            ],
          ],
        ));
  }

  Widget _buildRecommendItem({
    required BuildContext context,
    required int laneId,
    required String category,
    required String title,
    required String description,
    required String image,
    required String period,
    required int likeCount,
    required bool isLiked,
  }) {
    return LaneListItem(
      category: category,
      title: title,
      description: description,
      image: image,
      period: period,
      likeCount: likeCount,
      isLiked: isLiked,
      onLike: () {
        context.read<HomeBloc>().add(HomeLikeLane(laneId));
      },
      onUnlike: () {
        context.read<HomeBloc>().add(HomeUnlikeLane(laneId));
      },
      onClick: () {
        context.push('${Routes.lanes.path}/$laneId');
      },
    );
  }

  Widget _buildRestaurantBody({
    required BuildContext context,
    required List<LocalRestaurant> localRestaurants,
    required VoidCallback onShowMore,
    required Function(int) onItemClick,
  }) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("지역 맛집", style: TextStyles.headlineXSmall),
                  GestureDetector(
                    onTap: onShowMore,
                    child: Row(
                      children: [
                        Text(
                          "더보기",
                          style: TextStyles.bodyMedium.copyWith(
                            color: ColorStyles.gray500,
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/ic_arrow_right.svg",
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 223,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  for (final restaurant in localRestaurants) ...[
                    GestureDetector(
                      onTap: () => {
                        onItemClick(restaurant.tourAreaId),
                      },
                      child: _buildRestaurantItem(
                        context: context,
                        tourAreaId: restaurant.tourAreaId,
                        name: restaurant.name,
                        image: restaurant.image,
                        likeCount: restaurant.likeCount,
                        location: restaurant.sigunguValue,
                        isLiked: restaurant.likedByMe,
                      ),
                    ),
                    const SizedBox(width: 14),
                  ]
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildRestaurantItem({
    required BuildContext context,
    required int tourAreaId,
    required String name,
    required String? image,
    required int likeCount,
    required String location,
    required bool isLiked,
  }) {
    return RestaurantListItem(
      name: name,
      image: image,
      likeCount: likeCount,
      location: location,
      isLiked: isLiked,
      onClick: () {

      },
      onLike: () {
        context.read<HomeBloc>().add(HomeLikeTourArea(tourAreaId));
      },
      onUnlike: () {
        context.read<HomeBloc>().add(HomeUnlikeTourArea(tourAreaId));
      },
    );
  }

  Widget _buildPopularPlaceBody({
    required List<PopularDestination> popularDestinations,
    required VoidCallback onShowMore,
    required Function(int) onItemClick,
  }) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("인기 여행지 순위", style: TextStyles.headlineXSmall),
                  GestureDetector(
                    onTap: onShowMore,
                    child: Row(
                      children: [
                        Text(
                          "더보기",
                          style: TextStyles.bodyMedium.copyWith(
                            color: ColorStyles.gray500,
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/ic_arrow_right.svg",
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 223,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  for (final place in popularDestinations) ...[
                    GestureDetector(
                      onTap: () => {
                        onItemClick(place.tourAreaId),
                      },
                      child: PopularDestinationListItem(
                        rank: place.ranking,
                        name: place.name,
                        image: place.image,
                        location: place.sigunguValue,
                        category: place.category.title,
                      ),
                    ),
                    const SizedBox(width: 14),
                  ]
                ],
              ),
            )
          ],
        ));
  }
}

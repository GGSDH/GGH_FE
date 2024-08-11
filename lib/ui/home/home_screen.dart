import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/lane/lane_list_item.dart';
import 'package:gyeonggi_express/ui/component/restaurant/restaurant_list_item.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/lane_response.dart';
import '../../data/models/response/local_restaurant_response.dart';
import '../../data/repository/trip_repository.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_image_plaeholder.dart';
import 'home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        tripRepository: GetIt.instance<TripRepository>(),
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
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
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
                    _buildBanner(),
                    _buildCategories(
                          (category) {
                        GoRouter.of(context).push(
                            Uri(
                              path: Routes.categoryDetail.path,
                              queryParameters: { 'name': category },
                            ).toString()
                        );
                      },
                    ),
                    _buildRecommendBody(lanes: state.lanes),
                    _buildRestaurantBody(localRestaurants: state.localRestaurants),
                    _buildPopularPlaceBody(popularDestinations: state.popularDestinations)
                  ],
                ),
              );
            }
          }
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
                        // Handle heart icon tap
                      },
                    ),
                    const SizedBox(width: 14),
                    _buildIconButton(
                      "assets/icons/ic_search_white.svg",
                      () {
                        // Handle search icon tap
                      },
                    ),
                  ],
                )
              ])),
    );
  }

  Widget _buildBanner() {
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
            _buildAppBar(),
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

  Widget _buildCategories(Function (String category) onTapCategory) {
    final categories = ['체험', '핫플', '관광', '지역특색', '문화', '맛집', '힐링'];

    return SizedBox(
      height: 108,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          for (final category in categories) ...[
            _buildCategoryItem(
                "assets/icons/ic_category.svg",
                category,
                () { onTapCategory(category);
              }
            ),
            const SizedBox(width: 8)
          ]
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      String assetPath, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 60,
            child: Text(
              title,
              style: const TextStyle(
                  color: ColorStyles.gray800,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecommendBody({
    required List<Lane> lanes,
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
                    text: "전예나님",
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
                  onTap: () {
                    // Handle more tap
                  },
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
            _buildRecommendItem(
              category: lane.category,
              title: lane.laneName,
              description: "설명",
              period: "4박 5일",
              likeCount: lane.likeCount,
              isLiked: lane.likedByMe,
            ),
          ],
        ],
      )
    );
  }

  Widget _buildRecommendItem({
    required String category,
    required String title,
    required String description,
    required String period,
    required int likeCount,
    required bool isLiked,
  }) {
    return LaneListItem(
        category: category,
        title: title,
        description: description,
        period: period,
        likeCount: likeCount,
        isLiked: isLiked);
  }

  Widget _buildRestaurantBody({
    required List<LocalRestaurant> localRestaurants,
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
                    onTap: () {
                      // Handle more tap
                    },
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
                    _buildRestaurantItem(
                      name: restaurant.name,
                      image: restaurant.image,
                      likeCount: restaurant.likeCount,
                      location: restaurant.sigunguValue,
                      isLiked: restaurant.likedByMe,
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
    required String name,
    required String? image,
    required int likeCount,
    required String location,
    required bool isLiked
  }) {
    return RestaurantListItem(
      name: name,
      image: image,
      likeCount: likeCount,
      location: location,
      isLiked: isLiked,
    );
  }

  Widget _buildPopularPlaceBody({
    required List<PopularDestination> popularDestinations
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
                    onTap: () {
                      // Handle more tap
                    },
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
                    _buildPopularPlaceItem(
                      rank: place.ranking,
                      name: place.name,
                      image: place.image,
                      location: place.sigunguValue,
                      category: place.category,
                    ),
                    const SizedBox(width: 14),
                  ]
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildPopularPlaceItem({
    required int rank,
    required String name,
    required String? image,
    required String location,
    required String category
  }) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: image ?? "",
                        placeholder: (context, url) => const AppImagePlaceholder(width: 200, height: 145),
                        errorWidget: (context, url, error) => const AppImagePlaceholder(width: 200, height: 145),
                        width: 145,
                        height: 145,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: ColorStyles.gray800,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                        ),
                        child: Text("$rank",
                            style: TextStyles.titleXSmall
                                .copyWith(color: ColorStyles.grayWhite)))
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: TextStyles.titleMedium.copyWith(
                    color: ColorStyles.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$location | $category",
                  style: TextStyles.bodyMedium.copyWith(
                    color: ColorStyles.gray500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

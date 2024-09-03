import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_detail_response.dart';
import 'package:gyeonggi_express/data/models/tour_content_type.dart';
import 'package:gyeonggi_express/data/repository/tour_area_repository.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/%08blog/blog_list_item.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/component/lane/lane_list_item.dart';
import 'package:gyeonggi_express/ui/component/restaurant/restaurant_list_item.dart';
import 'package:gyeonggi_express/ui/station/station_detail_bloc.dart';

import '../../data/models/response/lane_response.dart';

class StationDetailScreen extends StatelessWidget {
  final int stationId;

  const StationDetailScreen({super.key, required this.stationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StationDetailBloc(GetIt.instance<TourAreaRepository>())
            ..add(FetchStationDetail(stationId: stationId)),
      child: const StationDetailView(),
    );
  }
}

class StationDetailView extends StatefulWidget {
  const StationDetailView({super.key});

  @override
  State<StationDetailView> createState() => _StationDetailViewState();
}

class _StationDetailViewState extends State<StationDetailView> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          /* bottomNavigationBar: _bottomNavigationBar(), */
          body: BlocBuilder<StationDetailBloc, StationDetailState>(
            builder: (context, state) {
              if (state is StationDetailLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      AppActionBar(
                          rightText: "",
                          onBackPressed: () => {},
                          menuItems: [
                            ActionBarMenuItem(
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_map.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.black, BlendMode.srcIn),
                                ),
                                onPressed: () => print("map clicked")),
                            ActionBarMenuItem(
                                icon: SvgPicture.asset(
                                  "assets/icons/ic_heart.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.black, BlendMode.srcIn),
                                ),
                                onPressed: () => print("like clicked")),
                          ]),
                      _imageViewer(state.data),
                      _stationHeader(state.data),
                      const Divider(
                        color: ColorStyles.gray100,
                        thickness: 1,
                      ),
                      /* state.data.tourArea.contentType !=
                              TourContentType.RESTAURANT
                          ? _stationSpotSummary(state.data)
                          : _stationRestaurantSummary(state.data), */
                      /* const Divider(
                        color: ColorStyles.gray100,
                        thickness: 1,
                      ), */
                      _laneIncludingStation(state.data),
                      const Divider(
                        color: ColorStyles.gray100,
                        thickness: 1,
                      ),
                      _nearbyRecommendations(state.data),
                      /*  const Divider(
                        color: ColorStyles.gray100,
                        thickness: 1,
                      ), */
                      /* _buildBlogReviews(state.data), */
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        )));
  }

  Widget _bottomNavigationBar() {
    return Container(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _buildNavigationItem(
                  SvgPicture.asset(
                    "assets/icons/ic_marker_01.svg",
                    width: 24,
                    height: 24,
                  ),
                  "1"),
              _buildNavigationItem(
                  SvgPicture.asset(
                    "assets/icons/ic_heart.svg",
                    width: 24,
                    height: 24,
                  ),
                  "2"),
              _buildNavigationItem(
                  SvgPicture.asset(
                    "assets/icons/ic_message_circle_2.svg",
                    width: 24,
                    height: 24,
                  ),
                  "3"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(Widget icon, String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 14, 0, 9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyles.bodyXSmall.copyWith(
                color: ColorStyles.gray500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _laneIncludingStation(TourAreaDetail data) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("이 역이 포함된 노선들", style: TextStyles.headlineXSmall),
                /* Row(
                  children: [
                    Text("더보기",
                        style: TextStyles.bodyMedium
                            .copyWith(color: ColorStyles.gray500)),
                    SvgPicture.asset(
                      "assets/icons/ic_arrow_right.svg",
                      width: 20,
                      height: 20,
                    )
                  ],
                ) */
              ]),
        ),
        ...data.lanes.map(
          (lane) => LaneListItem(
            category: lane.theme.title,
            title: lane.name,
            description: '',
            image: lane.photo,
            period: '',
            likeCount: lane.likeCount,
            isLiked: false,
          ),
        ),
      ],
    );
  }

  /* Widget _stationSpotSummary(TourAreaDetail data) {
    final spotSummary = data.spotSummary!;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spotSummary.title, style: TextStyles.titleLarge),
            const SizedBox(
              height: 8,
            ),
            Text(
              spotSummary.description,
              style: TextStyles.bodyLarge.copyWith(color: ColorStyles.gray600),
            ),
            const SizedBox(
              height: 24,
            ),
            Image.network(
              spotSummary.summaryImageUrl,
              fit: BoxFit.cover,
              height: 295,
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }

  Widget _stationRestaurantSummary(TourAreaDetail data) {
    final restaurantSummary = data.restaurantSummary!;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Restaurant Menu", style: TextStyles.titleLarge),
          ),
          ...restaurantSummary.menus.map(
            (menu) => _restaurantMenuItem(
              menu.imageUrl,
              menu.title,
              menu.description,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _restaurantMenuItem(
      String imageUrl, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: TextStyles.titleLarge.copyWith(color: ColorStyles.gray900),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            description,
            style: TextStyles.bodyLarge.copyWith(color: ColorStyles.gray600),
          ),
        ],
      ),
    );
  } */

  Widget _stationHeader(TourAreaDetail data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 18,
                child: SvgPicture.asset(
                  "assets/icons/ic_map_pin.svg",
                  width: 18,
                  height: 18,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                data.tourArea.sigungu.value,
                style: TextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w400, color: ColorStyles.primary),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(data.tourArea.name, style: TextStyles.title2ExtraLarge),
          /* const SizedBox(
            height: 4,
          ), */
          /* Text(data.subtitle,
              style: TextStyles.bodyLarge.copyWith(color: ColorStyles.gray600)), */
          if (data.tourArea.telNo != null &&
              data.tourArea.telNo!.isNotEmpty) ...[
            const SizedBox(
              height: 8,
            ),
            Container(
              color: ColorStyles.gray50,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      "전화",
                      style: TextStyles.titleSmall.copyWith(
                          color: ColorStyles.gray800,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data.tourArea.telNo!,
                      style: TextStyles.titleSmall.copyWith(
                          color: ColorStyles.gray600,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _nearbyRecommendations(TourAreaDetail data) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("주변 추천 장소", style: TextStyles.headlineXSmall),
              /* Row(
                children: [
                  Text("더보기",
                      style: TextStyles.bodyMedium
                          .copyWith(color: ColorStyles.gray500)),
                  SvgPicture.asset(
                    "assets/icons/ic_arrow_right.svg",
                    width: 20,
                    height: 20,
                  )
                ],
              ) */
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: data.otherTourAreas
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: EdgeInsets.only(
                        right: entry.key != data.otherTourAreas.length - 1
                            ? 14
                            : 0,
                      ),
                      child: RestaurantListItem(
                        name: entry.value.name,
                        location: entry.value.sigungu.value,
                        image: entry.value.image,
                        isLiked: entry.value.likedByMe,
                        likeCount: entry.value.likeCount,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        )
      ],
    );
  }

  /* Widget _buildBlogReviews(TourAreaDetail data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("추천 블로그 리뷰", style: TextStyles.headlineXSmall),
                Row(
                  children: [
                    Text("더보기",
                        style: TextStyles.bodyMedium
                            .copyWith(color: ColorStyles.gray500)),
                    SvgPicture.asset(
                      "assets/icons/ic_arrow_right.svg",
                      width: 20,
                      height: 20,
                    )
                  ],
                )
              ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: data.blogItems.map(
                (blogItem) {
                  final index = data.blogItems.indexOf(blogItem);
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index != data.blogItems.length - 1 ? 14 : 0,
                    ),
                    child: BlogListItem(
                      title: blogItem.title,
                      date: blogItem.date,
                      imageUrl: blogItem.imageUrl,
                      articleUrl: blogItem.articleUrl,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 34,
        )
      ],
    );
  } */

  Widget _imageViewer(TourAreaDetail data) {
    return SizedBox(
      height: 295,
      child: Stack(
        children: [
          if (data.tourArea.image != null && data.tourArea.image!.isNotEmpty)
            PageView.builder(
                onPageChanged: (value) => {
                      setState(() {
                        _currentPage = value;
                      })
                    },
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Image.network(
                    data.tourArea.image!,
                    fit: BoxFit.cover,
                    height: 295,
                    width: double.infinity,
                  );
                }),
          /* Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "${_currentPage + 1}/${data.images.length}",
                style: TextStyles.titleXSmall.copyWith(
                    fontWeight: FontWeight.w600, color: ColorStyles.grayWhite),
              ),
            ),
          ) */
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/response/lane_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/component/lane/lane_list_item.dart';
import 'package:gyeonggi_express/ui/component/place/place_list_item.dart';
import 'package:gyeonggi_express/ui/favorite/favorite_bloc.dart';

import '../../routes.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            AppActionBar(
              rightText: "",
              onBackPressed: () => GoRouter.of(context).pop(),
              menuItems: const [],
            ),
            const TabBar(
              tabs: [
                Tab(text: '노선'),
                Tab(text: '역'),
              ],
              indicatorColor: ColorStyles.gray900,
              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.black,
              unselectedLabelColor: ColorStyles.gray400,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildContent(isLaneTab: true),
                  _buildContent(isLaneTab: false),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildContent({required bool isLaneTab}) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          final items = isLaneTab ? state.lanes : state.tourAreas;
          if (items.isEmpty) {
            return _buildEmptyState(context, isLaneTab);
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              if (isLaneTab) {
                final lane = items[index] as Lane;
                return LaneListItem(
                  onLike: () {
                    context.read<FavoritesBloc>().add(LikeLane(lane.laneId));
                  },
                  onUnlike: () {
                    context.read<FavoritesBloc>().add(UnlikeLane(lane.laneId));
                  },
                  onClick: () {
                    GoRouter.of(context)
                        .push('${Routes.lanes.path}/${lane.laneId}');
                  },
                  category: lane.category.title,
                  title: lane.laneName,
                  description: '',
                  image: lane.image,
                  period: lane.getPeriodString(),
                  likeCount: lane.likeCount,
                  isLiked: lane.likedByMe,
                );
              } else {
                final tourArea = items[index] as TourAreaSummary;
                return PlaceListItem(
                  name: tourArea.tourAreaName,
                  description: '',
                  image: tourArea.image,
                  likeCount: tourArea.likeCnt,
                  likedByMe: tourArea.likedByMe,
                  sigunguValue: tourArea.sigunguCode.value,
                  onClick: () {
                    GoRouter.of(context)
                        .push('${Routes.stations.path}/${tourArea.tourAreaId}');
                  },
                  onLike: () {
                    context
                        .read<FavoritesBloc>()
                        .add(LikeTourArea(tourArea.tourAreaId));
                  },
                  onUnlike: () {
                    context
                        .read<FavoritesBloc>()
                        .add(UnlikeTourArea(tourArea.tourAreaId));
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isLaneTab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_search_empty.svg',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 16),
          Text(
            isLaneTab ? "찜한 노선이 없어요" : "찜한 역이 없어요",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isLaneTab ? "내 마음에 쏙 드는 노선을 찜하러 가볼까요?" : "인기 여행지를 찜하러 가볼까요?",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorStyles.gray500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (isLaneTab) {
                GoRouter.of(context)
                    .go("${Routes.home.path}/${Routes.recommendedLanes.path}");
              } else {
                GoRouter.of(context).go(
                    "${Routes.home.path}/${Routes.popularDestinations.path}");
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorStyles.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "바로가기",
              style:
                  TextStyles.titleXSmall.copyWith(color: ColorStyles.grayWhite),
            ),
          ),
        ],
      ),
    );
  }
}

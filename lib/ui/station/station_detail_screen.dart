import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_related_lane.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/component/lane/lane_list_item.dart';
import 'package:gyeonggi_express/ui/component/restaurant/restaurant_list_item.dart';
import 'package:gyeonggi_express/ui/station/station_detail_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/response/tour_area_response.dart';
import '../../routes.dart';
import '../component/app/app_image_plaeholder.dart';

class StationDetailScreen extends StatelessWidget {
  final int stationId;

  const StationDetailScreen({super.key, required this.stationId});

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<StationDetailBloc, StationDetailSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is StationDetailShowError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(sideEffect.message)),
          );
        }
      },
      child: BlocBuilder<StationDetailBloc, StationDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Material(
              color: Colors.white,
              child: SafeArea(
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppActionBar(
                        rightText: "",
                        onBackPressed: () => GoRouter.of(context).pop(),
                        menuItems: [
                          ActionBarMenuItem(
                            icon: SvgPicture.asset(
                              "assets/icons/ic_map.svg",
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                  Colors.black, BlendMode.srcIn),
                            ),
                            onPressed: () async {
                              String formattedLatitude = state.tourArea.latitude.toStringAsFixed(6);
                              String formattedLongitude = state.tourArea.longitude.toStringAsFixed(6);
                              String encodedTourArea = Uri.encodeComponent(state.tourArea.name);

                              final url = "nmap://route/public?dlat=$formattedLatitude&dlng=$formattedLongitude&dname=$encodedTourArea&appname=com.ggsdh.gyeonggiexpress";

                              print(url);

                              final canLaunch = await canLaunchUrl(Uri.parse(url));
                              if (canLaunch) {
                                await launchUrl(
                                  Uri.parse(url),
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                final store = Platform.isIOS
                                    ? "http://itunes.apple.com/app/id311867728?mt=8"
                                    : "market://details?id=com.nhn.android.nmap";
                                await launchUrl(Uri.parse(store), mode: LaunchMode.externalApplication);
                              }
                            },
                          ),
                          ActionBarMenuItem(
                            icon: SvgPicture.asset(
                              (state.tourArea.likedByMe) ? "assets/icons/ic_heart_filled.svg" : "assets/icons/ic_heart.svg",
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                  (state.tourArea.likedByMe) ? Colors.red : Colors.black, BlendMode.srcIn),
                            ),
                            onPressed: () => {
                              if (state.tourArea.likedByMe) {
                                context.read<StationDetailBloc>().add(
                                  UnlikeStation(state.tourArea.tourAreaId),
                                )
                              } else {
                                context.read<StationDetailBloc>().add(
                                  LikeStation(state.tourArea.tourAreaId),
                                )
                              }
                            },
                          ),
                        ],
                      ),
                      _imageViewer(state.tourArea.image),
                      _stationHeader(state.tourArea),
                      const Divider(
                        color: ColorStyles.gray100,
                        thickness: 1,
                      ),
                      if (state.lanes.isNotEmpty) ...[
                        _laneIncludingStation(
                          lanes: state.lanes,
                          onClick: (id) => {
                            GoRouter.of(context).push("${Routes.lanes.path}/$id")
                          },
                          onLike: (id) => {
                            context.read<StationDetailBloc>().add(
                              LikeIncludingLane(id),
                            )
                          },
                          onUnlike: (id) => {
                            context.read<StationDetailBloc>().add(
                              UnlikeIncludingLane(id),
                            )
                          },
                        ),
                        const Divider(
                          color: ColorStyles.gray100,
                          thickness: 1,
                        ),
                      ],
                      _nearbyRecommendations(
                        recommendations: state.otherTourAreas,
                        onClick: (id) => {
                          GoRouter.of(context).push("${Routes.stations.path}/$id")
                        },
                        onLike: (id) => {
                          context.read<StationDetailBloc>().add(
                            LikeRecommendation(id),
                          )
                        },
                        onUnlike: (id) => {
                          context.read<StationDetailBloc>().add(
                            UnlikeRecommendation(id),
                          )
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _laneIncludingStation({
    required List<TourAreaRelatedLane> lanes,
    required Function(int) onClick,
    required Function(int) onLike,
    required Function(int) onUnlike,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("이 역이 포함된 노선들", style: TextStyles.headlineXSmall),
        ),
        ...lanes.map(
              (lane) => LaneListItem(
            onClick: () => onClick(lane.laneId),
            onLike: () => onLike(lane.laneId),
            onUnlike: () => onUnlike(lane.laneId),
            category: lane.theme.title,
            title: lane.name,
            description: '',
            image: lane.photo,
            period: '',
            likeCount: lane.likeCount,
            isLiked: lane.likedByMe,
          ),
        ),
      ],
    );
  }

  Widget _stationHeader(TourAreaResponse tourArea) {
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
                tourArea.sigungu.value,
                style: TextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w400, color: ColorStyles.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(tourArea.name, style: TextStyles.title2ExtraLarge),
          if (tourArea.telNo != null && tourArea.telNo!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              color: ColorStyles.gray50,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      "전화",
                      style: TextStyles.titleSmall.copyWith(
                          color: ColorStyles.gray800, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tourArea.telNo!,
                      style: TextStyles.titleSmall.copyWith(
                          color: ColorStyles.gray600, fontWeight: FontWeight.w400),
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

  Widget _nearbyRecommendations({
    required List<TourAreaResponse> recommendations,
    required Function(int) onClick,
    required Function(int) onLike,
    required Function(int) onUnlike,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("주변 추천 장소", style: TextStyles.headlineXSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,  // This allows content to overflow outside the padding area
            child: Row(
              children: recommendations
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                  padding: EdgeInsets.only(
                    right: entry.key != recommendations.length - 1 ? 14 : 0,
                  ),
                  child: RestaurantListItem(
                    onClick: () => onClick(entry.value.tourAreaId),
                    onLike: () => onLike(entry.value.tourAreaId),
                    onUnlike: () => onUnlike(entry.value.tourAreaId),
                    name: entry.value.name,
                    location: entry.value.sigungu.value,
                    image: entry.value.image,
                    isLiked: entry.value.likedByMe,
                    likeCount: entry.value.likeCount,
                  ),
                ),
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageViewer(String? imageUrl) {
    return AspectRatio(
      aspectRatio: 1.33,
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? "",
        placeholder: (context, url) =>
        const AppImagePlaceholder(width: double.infinity, height: double.infinity),
        errorWidget: (context, url, error) =>
        const AppImagePlaceholder(width: double.infinity, height: double.infinity),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_lane_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/lane_specific_response.dart';
import '../../data/models/response/recommended_lane_response.dart';
import '../../data/models/response/tour_area_summary_response.dart';
import '../../data/models/trip_theme.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../util/naver_map_util.dart';
import '../../util/toast_util.dart';
import '../component/app/app_image_plaeholder.dart';

class RecommendResultScreen extends StatefulWidget {
  final int days;
  final List<SigunguCode> sigunguCodes;
  final List<TripTheme> tripThemes;

  RecommendResultScreen({
    super.key,
    required this.days,
    required this.sigunguCodes,
    required this.tripThemes,
  });

  @override
  _RecommendResultScreen createState() => _RecommendResultScreen();
}

class _RecommendResultScreen extends State<RecommendResultScreen> {
  NaverMapController? _mapController;
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<RecommendLaneBloc, RecommendLaneSideEffect>(
      listener: (BuildContext context, RecommendLaneSideEffect sideEffect) {
        if (sideEffect is RecommendLaneShowError) {
          ToastUtil.showToast(context, sideEffect.message);
        }
      },
      child: BlocBuilder<RecommendLaneBloc, RecommendLaneState>(
        builder: (context, state) {
          return Scaffold(
            body: Material(
              color: Colors.white,
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                child: DefaultTabController(
                  length: 2,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          AppActionBar(
                            onBackPressed: () {
                              GoRouter.of(context).go(Routes.recommend.path);
                            },
                            menuItems: [
                              ActionBarMenuItem(
                                icon: SvgPicture.asset(
                                  (state.isLikedByMe) ? "assets/icons/ic_heart_filled.svg" : "assets/icons/ic_heart.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                      (state.isLikedByMe) ? Colors.red : Colors.black, BlendMode.srcIn),
                                ),
                                onPressed: () => {
                                  if (state.isLikedByMe) {
                                    context.read<RecommendLaneBloc>().add(
                                      RecommendLaneUnlike(state.data.id),
                                    )
                                  } else {
                                    context.read<RecommendLaneBloc>().add(
                                      RecommendLaneLike(state.data.id),
                                    )
                                  }
                                },
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                            child: _laneHeader(
                              state.data.title,
                              _formatDays(widget.days),
                              widget.sigunguCodes.first.value,
                              widget.tripThemes.first.title,
                            ),
                          ),
                          const TabBar(
                            tabs: [
                              Tab(text: '코스'),
                              Tab(text: '지도'),
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
                                _laneCourseWidget(state.data),
                                _mapViewWidget(state.data),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mapViewWidget(RecommendedLaneResponse laneData) {
    return Stack(
      children: [
        _naverMapSection(),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomSheetLikeView(laneData),
        ),
      ],
    );
  }

  Widget _buildBottomSheetLikeView(RecommendedLaneResponse laneData) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(
              top: BorderSide(color: ColorStyles.gray200, width: 1),
              left: BorderSide(color: ColorStyles.gray200, width: 1),
              right: BorderSide(color: ColorStyles.gray200, width: 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Day ${_selectedDayIndex + 1}",
                            style: TextStyles.titleMedium.copyWith(
                                color: ColorStyles.gray900,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () { _showBottomSheet(laneData); },
                          child: SvgPicture.asset(
                            "assets/icons/ic_chevron_right.svg",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 120,
                      child: PageView.builder(
                        controller: PageController(),
                        itemCount: laneData.days[_selectedDayIndex].tourAreas.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final tourArea = laneData.days[_selectedDayIndex].tourAreas;
                          return _placeDetailItemInBottomSheet(tourArea[index].tourAreaResponse);
                        },
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheet(RecommendedLaneResponse laneData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 4,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 14),
                decoration: BoxDecoration(
                  color: ColorStyles.gray200,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: laneData.days.length,
                    itemBuilder: (context, idx) {
                      bool isSelected = idx == _selectedDayIndex;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Day ${idx + 1}',
                            style: TextStyle(
                              color: isSelected
                                  ? ColorStyles.primary
                                  : ColorStyles.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: isSelected
                              ? SvgPicture.asset(
                                  "assets/icons/ic_check_filled.svg",
                                  width: 24,
                                  height: 24,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = idx;
                              _updateMapMarkers(laneData);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _laneHeader(
    String title,
    String period,
    String category,
    String theme
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorStyles.primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              category,
              style: TextStyles.titleXSmall.copyWith(
                color: ColorStyles.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: TextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorStyles.gray900,
          ),
        ),
        Text(
          "$period | $theme",
          style: TextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorStyles.gray500,
          ),
        ),
      ],
    );
  }

  Widget _laneDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 29.5),
      child: Row(
        children: [
          Container(
            width: 1,
            height: 14,
            color: ColorStyles.primary,
          ),
          const SizedBox(width: 31),
          const Expanded(child: SizedBox(height: 14)),
        ],
      ),
    );
  }

  void _moveCameraToLocation(TourAreaSummary tourArea) {
    if (_mapController != null) {
      _mapController!.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(tourArea.latitude, tourArea.longitude),
          zoom: 13,
        ),
      );
    }
  }

  Widget _placeDetailItemInBottomSheet(TourAreaSummary tourArea) {
    return GestureDetector(
      onTap: () => _moveCameraToLocation(tourArea),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorStyles.primary,
                      width: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: ColorStyles.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push("${Routes.stations.path}/${tourArea.tourAreaId}");
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: tourArea.image,
                      placeholder: (context, url) => const AppImagePlaceholder(width: 80, height: 80),
                      errorWidget: (context, url, error) => const AppImagePlaceholder(width: 80, height: 80),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),  // 텍스트와 이미지 간격을 위해 간격 추가
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tourArea.tourAreaName,
                          style: TextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorStyles.gray800),
                          overflow: TextOverflow.ellipsis,  // 길면 줄임표로 처리
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${tourArea.sigunguCode.value} | ${tourArea.tripTheme.title}",
                          style: TextStyles.bodyMedium.copyWith(
                              color: ColorStyles.gray500,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,  // 길면 줄임표로 처리
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SvgPicture.asset(
                              (tourArea.likedByMe) ? "assets/icons/ic_heart_filled.svg" : "assets/icons/ic_heart.svg",
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              tourArea.likeCnt.toString(),
                              style: TextStyles.bodyXSmall.copyWith(
                                  color: ColorStyles.gray600,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _laneCourseWidget(RecommendedLaneResponse laneData) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...laneData.days.expand((day) => [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                      child: Text(
                        "Day ${day.day}",
                        style: TextStyles.titleLarge.copyWith(
                            color: ColorStyles.gray900,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ...day.tourAreas.expand((area) => [
                      _lanePlace(area.tourAreaResponse),
                      if (day.tourAreas.last != area) _laneDivider(),
                    ]),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _lanePlace(TourAreaSummary place) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorStyles.primary,
                      width: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 1,
                    color: ColorStyles.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.tourAreaName,
                      style: TextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorStyles.gray800)),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(place.sigunguCode.value,
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray500,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(width: 4),
                            Text("|",
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray300,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(width: 4),
                            Text(place.tripTheme.title,
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray500,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        (place.likedByMe) ? "assets/icons/ic_heart_filled.svg" : "assets/icons/ic_heart.svg",
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 2),
                      Text(place.likeCnt.toString(),
                          style: TextStyles.bodyXSmall.copyWith(
                              color: ColorStyles.gray600,
                              fontWeight: FontWeight.w400)),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push("${Routes.stations.path}/${place.tourAreaId}");
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: place.image,
                                placeholder: (context, url) => const AppImagePlaceholder(width: 240, height: 150),
                                errorWidget: (context, url, error) => const AppImagePlaceholder(width: 240, height: 150),
                                width: 240,
                                height: 150,
                                fit: BoxFit.cover
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _naverMapSection() {
    return NaverMap(
      forceGesture: true,
      options: const NaverMapViewOptions(
      indoorEnable: true,
      locationButtonEnable: false,
      consumeSymbolTapEvents: false,
      ),
      onMapReady: (controller) {
      _mapController = controller;
      _updateMapMarkers(context.read<RecommendLaneBloc>().state.data);
      },
    );
  }

  void _updateMapMarkers(RecommendedLaneResponse data) {
    if (_mapController == null) return;

    _mapController!.clearOverlays();
    List<LaneSpecificResponse> selectedDayResponses = data.days
        .firstWhere((dayPlan) => dayPlan.day == _selectedDayIndex + 1)
        .tourAreas;
    NaverMapUtil.addMarkersAndPathForLane(
        _mapController!, selectedDayResponses, context);

    // 카메라 위치 업데이트
    if (selectedDayResponses.isNotEmpty) {
      var firstPlace = selectedDayResponses.first.tourAreaResponse;
      _mapController!.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(firstPlace.latitude, firstPlace.longitude),
          zoom: 14,
        ),
      );
    }
  }
}

String _formatDays(int days) {
  if (days == 1) {
    return "당일치기";
  } else {
    return "${days - 1}박 $days일";
  }
}


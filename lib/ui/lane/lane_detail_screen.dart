import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/response/lane_detail_response.dart';
import 'package:gyeonggi_express/data/models/response/lane_specific_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/lane/lane_detail_bloc.dart';
import 'package:gyeonggi_express/util/naver_map_util.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../routes.dart';
import '../../util/toast_util.dart';
import '../component/app/app_image_plaeholder.dart';

class LaneDetailScreen extends StatefulWidget {
  final int laneId;

  const LaneDetailScreen({super.key, required this.laneId});

  @override
  _LaneDetailScreenState createState() => _LaneDetailScreenState();
}

class _LaneDetailScreenState extends State<LaneDetailScreen> {
  NaverMapController? _mapController;
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<LaneDetailBloc, LaneDetailSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is LaneDetailShowError) {
          ToastUtil.showToast(context, sideEffect.message);
        }
      },
      child: BlocBuilder<LaneDetailBloc, LaneDetailState>(
        builder: (context, state) {
          return Scaffold(
            body: Material(
              color: Colors.white,
              child: SafeArea(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      AppActionBar(
                        onBackPressed: () => GoRouter.of(context).pop(),
                        menuItems: [
                          ActionBarMenuItem(
                            icon: SvgPicture.asset(
                              (state.isLikedByMe)
                                  ? "assets/icons/ic_heart_filled.svg"
                                  : "assets/icons/ic_heart.svg",
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                  (state.isLikedByMe)
                                      ? Colors.red
                                      : Colors.black,
                                  BlendMode.srcIn),
                            ),
                            onPressed: () => {
                              if (state.isLikedByMe)
                                {
                                  context.read<LaneDetailBloc>().add(
                                      LaneDetailUnlike(
                                          laneId: state.laneDetail.id))
                                }
                              else
                                {
                                  context.read<LaneDetailBloc>().add(
                                        LaneDetailLike(
                                            laneId: state.laneDetail.id),
                                      )
                                }
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                        child: _laneHeader(state.laneDetail),
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
                            _laneCourseWidget(state.laneDetail),
                            _mapViewWidget(state.laneDetail),
                          ],
                        ),
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

  Widget _mapViewWidget(LaneDetail laneDetail) {
    return Stack(
      children: [
        NaverMap(
          forceGesture: true,
          options: const NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: NLatLng(37.5666102, 126.9783881),
              zoom: 11,
            ),
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: false,
            rotationGesturesEnable: true,
            scrollGesturesEnable: true,
            zoomGesturesEnable: true,
          ),
          onMapReady: (controller) {
            _mapController = controller;
            _updateMapMarkers(laneDetail);
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomSheetLikeView(laneDetail),
        ),
      ],
    );
  }

  Widget _buildBottomSheetLikeView(LaneDetail laneDetail) {
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
                          onTap: () {
                            _showBottomSheet(laneDetail);
                          },
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
                        itemCount: laneDetail
                            .getTourAreasByDay(_selectedDayIndex + 1)
                            .length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final tourArea = laneDetail
                              .getTourAreasByDay(_selectedDayIndex + 1)[index];
                          return _placeDetailItemInBottomSheet(
                              index + 1, tourArea);
                        },
                      ),
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

  void _showBottomSheet(LaneDetail laneDetail) {
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
                    itemCount: laneDetail.getDaysWithTourAreas().length,
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
                            });
                            _updateMapMarkers(laneDetail);
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

  Widget _laneHeader(LaneDetail state) {
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
              state.category.title,
              style: TextStyles.titleXSmall.copyWith(
                color: ColorStyles.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          state.laneName,
          style: TextStyles.title2ExtraLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorStyles.gray900,
          ),
        ),
        Text(
          state.laneDescription ?? '',
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

  Widget _lanePlace(TourAreaSummary laneTourArea) {
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
              child: GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(
                      '${Routes.stations.path}/${laneTourArea.tourAreaId}');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(laneTourArea.tourAreaName,
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
                              Text(laneTourArea.sigunguCode.value,
                                  style: TextStyles.bodyMedium.copyWith(
                                      color: ColorStyles.gray500,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(width: 4),
                              Text("|",
                                  style: TextStyles.bodyMedium.copyWith(
                                      color: ColorStyles.gray300,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(width: 4),
                              Text(laneTourArea.sigunguCode.value,
                                  style: TextStyles.bodyMedium.copyWith(
                                      color: ColorStyles.gray500,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        SvgPicture.asset(
                            (laneTourArea.likedByMe)
                                ? "assets/icons/ic_heart_filled.svg"
                                : "assets/icons/ic_heart.svg",
                            width: 18,
                            height: 18),
                        const SizedBox(width: 2),
                        Text(laneTourArea.likeCnt.toString(),
                            style: TextStyles.bodyXSmall.copyWith(
                                color: ColorStyles.gray600,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                    imageUrl: laneTourArea.image,
                                    placeholder: (context, url) =>
                                        const AppImagePlaceholder(
                                            width: 150, height: 230),
                                    errorWidget: (context, url, error) =>
                                        const AppImagePlaceholder(
                                            width: 150, height: 230),
                                    width: 240,
                                    height: 150,
                                    fit: BoxFit.cover)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  Widget _placeDetailItemInBottomSheet(
      int orderNumber, TourAreaSummary laneTourArea) {
    return GestureDetector(
      onTap: () => _moveCameraToLocation(laneTourArea),
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
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(
                            "${Routes.stations.path}/${laneTourArea.tourAreaId}");
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: laneTourArea.image,
                          placeholder: (context, url) =>
                              const AppImagePlaceholder(width: 80, height: 80),
                          errorWidget: (context, url, error) =>
                              const AppImagePlaceholder(width: 80, height: 80),
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      top: 4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorStyles.primary,
                        ),
                        child: Center(
                          child: Text(
                            orderNumber.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          laneTourArea.tourAreaName,
                          maxLines: 1,
                          style: TextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorStyles.gray800),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                laneTourArea.tourAreaName,
                                maxLines: 1,
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray500,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SvgPicture.asset(
                              (laneTourArea.likedByMe)
                                  ? "assets/icons/ic_heart_filled.svg"
                                  : "assets/icons/ic_heart.svg",
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(width: 2),
                            Text(laneTourArea.likeCnt.toString(),
                                style: TextStyles.bodyXSmall.copyWith(
                                    color: ColorStyles.gray600,
                                    fontWeight: FontWeight.w400))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _laneCourseWidget(LaneDetail laneData) {
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
                children: laneData.getDaysWithTourAreas().expand((day) {
                  List<Widget> dayWidgets = [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                      child: Row(children: [
                        Text(
                          "Day $day",
                          style: TextStyles.titleLarge.copyWith(
                              color: ColorStyles.gray900,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "",
                          style: TextStyles.bodyLarge.copyWith(
                              color: ColorStyles.gray500,
                              fontWeight: FontWeight.w400),
                        ),
                      ]),
                    ),
                  ];

                  List<TourAreaSummary> tourAreas =
                      laneData.getTourAreasByDay(day);
                  dayWidgets.addAll(
                      tourAreas.map((place) => _lanePlace(place)).toList());

                  for (int i = 0; i < tourAreas.length - 1; i++) {
                    dayWidgets.add(_laneDivider());
                  }

                  return dayWidgets;
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateMapMarkers(LaneDetail laneDetail) {
    if (_mapController == null) return;

    _mapController!.clearOverlays();
    List<LaneSpecificResponse> selectedDayResponses = laneDetail
        .laneSpecificResponses
        .where((response) => response.day == _selectedDayIndex + 1)
        .toList();
    NaverMapUtil.addMarkersAndPathForLane(
        _mapController!, selectedDayResponses, context);

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

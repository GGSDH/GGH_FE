import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/response/lane_detail_response.dart';
import 'package:gyeonggi_express/data/models/response/lane_specific_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';
import 'package:gyeonggi_express/data/repository/lane_repository.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/lane/lane_detail_bloc.dart';
import 'package:gyeonggi_express/util/naver_map_util.dart';

class LaneDetailScreen extends StatelessWidget {
  final int laneId;

  const LaneDetailScreen({super.key, required this.laneId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaneDetailBloc(
        GetIt.instance<LaneRepository>(),
      )..add(FetchLaneDetail(laneId)),
      child: Scaffold(
        body: BlocBuilder<LaneDetailBloc, LaneDetailState>(
          builder: (context, state) {
            if (state is LaneDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LaneDetailLoaded) {
              return LaneDetailView(laneDetail: state.laneDetail);
            } else if (state is LaneDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Select a lane to view details'));
          },
        ),
      ),
    );
  }
}

class LaneDetailView extends StatefulWidget {
  final LaneDetail laneDetail;

  const LaneDetailView({super.key, required this.laneDetail});

  @override
  State<StatefulWidget> createState() => _LaneDetailViewState();
}

class _LaneDetailViewState extends State<LaneDetailView> {
  NaverMapController? _mapController;
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
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
                      "assets/icons/ic_heart.svg",
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        ColorStyles.gray800,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
                rightText: "",
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                child: _laneHeader(),
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
                    _laneCourseWidget(widget.laneDetail),
                    _mapViewWidget(widget.laneDetail),
                  ],
                ),
              ),
            ],
          ),
        ),
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
            _updateMapMarkers();
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
                          onTap: _showBottomSheet,
                          child: SvgPicture.asset(
                            "assets/icons/ic_chevron_right.svg",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.laneDetail
                            .getTourAreasByDay(_selectedDayIndex + 1)
                            .map((tourArea) =>
                                _placeDetailItemInBottomSheet(tourArea))
                            .toList(),
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

  void _showBottomSheet() {
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
                    itemCount: widget.laneDetail.getDaysWithTourAreas().length,
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
                            _updateMapMarkers();
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

  Widget _laneHeader() {
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
                color: const Color(0xFFFBB12C),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              widget.laneDetail.laneName,
              style: TextStyles.titleXSmall.copyWith(
                color: const Color(0xFFFBB12C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          widget.laneDetail.laneName,
          style: TextStyles.title2ExtraLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorStyles.gray900,
          ),
        ),
        Text(
          widget.laneDetail.laneName,
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
            color: const Color(0xFFFBB12C),
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
                      color: const Color(0xFFFBB12C),
                      width: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 1,
                    color: const Color(0xFFFBB12C),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
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
                        "assets/icons/ic_heart_filled.svg",
                        width: 18,
                        height: 18,
                      ),
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
                        if (laneTourArea.image.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                laneTourArea.image,
                                fit: BoxFit.cover,
                                height: 150,
                                width: 240,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 150,
                                    width: 240,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported,
                                          color: Colors.white60),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              height: 150,
                              width: 240,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Icon(Icons.image_not_supported,
                                    color: Colors.white60),
                              ),
                            ),
                          ),
                      ],
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

  void _moveCameraToLocation(TourAreaSummary tourArea) {
    if (_mapController != null &&
        tourArea.latitude != null &&
        tourArea.longitude != null) {
      _mapController!.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(tourArea.latitude!, tourArea.longitude!),
          zoom: 13,
        ),
      );
    }
  }

  Widget _placeDetailItemInBottomSheet(TourAreaSummary laneTourArea) {
    return GestureDetector(
      onTap: () => {_moveCameraToLocation(laneTourArea)},
      child: SizedBox(
        width: 300,
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
                      color: const Color(0xFFFBB12C),
                      width: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: const Color(0xFFFBB12C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (laneTourArea.image.isNotEmpty)
                    ? Image.network(
                        laneTourArea.image,
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 80,
                            width: 80,
                            color: Colors.grey,
                          );
                        },
                      )
                    : Container(
                        height: 80,
                        width: 80,
                        color: Colors.grey,
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
                              "assets/icons/ic_heart_filled.svg",
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

  void _updateMapMarkers() {
    if (_mapController == null) return;

    _mapController!.clearOverlays();
    List<LaneSpecificResponse> selectedDayResponses = widget
        .laneDetail.laneSpecificResponses
        .where((response) => response.day == _selectedDayIndex + 1)
        .toList();
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

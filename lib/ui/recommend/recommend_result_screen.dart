import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/recommend/recommend_lane_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/recommended_lane_response.dart';
import '../../data/models/response/recommended_tour_area_response.dart';
import '../../data/models/response/tour_area_response.dart';
import '../../data/models/trip_theme.dart';
import '../../themes/color_styles.dart';
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
  final Completer<NaverMapController> _mapControllerCompleter =
      Completer<NaverMapController>();
  int _selectedDayIndex = 0;

  final GlobalKey _containerKey = GlobalKey();
  double _bottomButtonsHeight = 72.0;

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<RecommendLaneBloc, RecommendLaneSideEffect>(
      listener: (BuildContext context, RecommendLaneSideEffect sideEffect) {
        if (sideEffect is RecommendLaneShowError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(sideEffect.message),
            ),
          );
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
                          SizedBox(
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20), // 우측에 20dp 간격 추가
                                  child: GestureDetector(
                                    onTap: () => {},
                                    child: SvgPicture.asset(
                                      "assets/icons/ic_close_24px.svg",
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _buildFixedBottomButtons(),
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
        _NaverMapSection(mapControllerCompleter: _mapControllerCompleter),
        Positioned(
          left: 0,
          right: 0,
          bottom: _bottomButtonsHeight,
          child: _buildBottomSheetLikeView(laneData),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeight());
  }

  void _updateHeight() {
    final RenderBox renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _bottomButtonsHeight = renderBox.size.height;
    });
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: laneData.days[_selectedDayIndex].tourAreas
                            .map(
                                (place) => _placeDetailItemInBottomSheet(place.tourArea))
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
                color: const Color(0xFFFBB12C),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              category,
              style: TextStyles.titleXSmall.copyWith(
                color: const Color(0xFFFBB12C),
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

  Widget _buildFixedBottomButtons() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          key: _containerKey,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE5E8EB),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorStyles.gray800,
                    foregroundColor: ColorStyles.grayWhite,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/ic_arrow_loop_right.svg",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "재추천 받기",
                        style: TextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.grayWhite),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _placeDetailItemInBottomSheet(RecommendedTourAreaResponse tourArea) {
    return SizedBox(
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
              ClipRRect(
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
                            "assets/icons/ic_heart_filled.svg",
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
                children: [
                  ...laneData.days.expand((day) => [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                      child: Row(
                        children: [
                          Text(
                            "Day ${day.day}",
                            style: TextStyles.titleLarge.copyWith(
                                color: ColorStyles.gray900,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Day ${day.day}",
                            style: TextStyles.bodyLarge.copyWith(
                                color: ColorStyles.gray500,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    ...day.tourAreas.expand((area) => [
                      _lanePlace(area.tourArea),
                      if (day.tourAreas.last != area) _laneDivider(),
                    ]),
                  ]),
                  SizedBox(height: _bottomButtonsHeight),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _lanePlace(RecommendedTourAreaResponse place) {
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
                        "assets/icons/ic_heart_filled.svg",
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (place.image.isNotEmpty)
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NaverMapSection extends StatelessWidget {
  const _NaverMapSection({required this.mapControllerCompleter});

  final Completer<NaverMapController> mapControllerCompleter;

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      forceGesture: true,
      options: const NaverMapViewOptions(
        indoorEnable: true,
        locationButtonEnable: false,
        consumeSymbolTapEvents: false,
      ),
      onMapReady: (controller) {
        mapControllerCompleter.complete(controller);
      },
    );
  }
}

String _formatDays(int days) {
  if (days == 1) {
    return "당일치기";
  } else {
    return "${days - 1}박 $days일";
  }
}
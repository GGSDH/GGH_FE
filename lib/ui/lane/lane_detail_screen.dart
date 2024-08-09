import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';

import '../../themes/color_styles.dart';

class LaneDetailScreen extends StatelessWidget {
  LaneDetailScreen({super.key});

  final Completer<NaverMapController> _mapControllerCompleter =
      Completer<NaverMapController>();

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
                onBackPressed: () => {},
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
                    onPressed: () => {},
                  ),
                  ActionBarMenuItem(
                    icon: SvgPicture.asset(
                      "assets/icons/ic_share.svg",
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        ColorStyles.gray800,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => {},
                  )
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
                    _laneCourseWidget(),
                    Stack(
                      children: [
                        _NaverMapSection(
                            mapControllerCompleter: _mapControllerCompleter),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _buildBottomSheetLikeView(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetLikeView() {
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
          child: SingleChildScrollView(
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
                              "Day1",
                              style: TextStyles.titleMedium.copyWith(
                                  color: ColorStyles.gray900,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            "assets/icons/ic_chevron_right.svg",
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [_placeDetailItemInBottomSheet(),_placeDetailItemInBottomSheet(),_placeDetailItemInBottomSheet()],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _placeDetailItemInBottomSheet() {
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
                child: Image.network(
                  "https://picsum.photos/800/800",
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Place Name",
                        style: TextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.gray800
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Region | Category",
                              style: TextStyles.bodyMedium.copyWith(
                                  color: ColorStyles.gray500,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/ic_heart_filled.svg",
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(width: 2),
                          Text(
                              "000",
                              style: TextStyles.bodyXSmall.copyWith(
                                  color: ColorStyles.gray600,
                                  fontWeight: FontWeight.w400
                              )
                          )
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
    );
  }

  Widget _laneCourseWidget() {
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                    child: Row(children: [
                      Text(
                        "Day 1",
                        style: TextStyles.titleLarge.copyWith(
                            color: ColorStyles.gray900,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "2024.12.31",
                        style: TextStyles.bodyLarge.copyWith(
                            color: ColorStyles.gray500,
                            fontWeight: FontWeight.w400),
                      ),
                    ]),
                  ),
                  _lanePlace(),
                  _laneDivider(),
                  _lanePlace(),
                  _laneDivider(),
                  _lanePlace()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _laneDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 29.5),
      child: Row(
        children: [
          Container(
            width: 1,
            height: 14,
            color: Color(0xFFFBB12C),
          ),
          SizedBox(width: 31),
          Expanded(child: SizedBox(height: 14)),
        ],
      ),
    );
  }

  Widget _lanePlace() {
    return Padding(
      padding: EdgeInsets.only(left: 20), // 선 앞에 20의 여백 추가
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
                      color: Color(0xFFFBB12C),
                      width: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 1,
                    color: Color(0xFFFBB12C), // #FBB12C 색상
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Place Name",
                      style: TextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorStyles.gray800)),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text("Region",
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray500,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(width: 4),
                            Text("|",
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray300,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(width: 4),
                            Text("Category",
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
                      SizedBox(width: 2),
                      Text("000",
                          style: TextStyles.bodyXSmall.copyWith(
                              color: ColorStyles.gray600,
                              fontWeight: FontWeight.w400)),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "https://picsum.photos/800/800",
                            fit: BoxFit.cover,
                            height: 150,
                            width: 240,
                          ),
                        ),
                        SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "https://picsum.photos/800/800",
                            fit: BoxFit.cover,
                            height: 150,
                            width: 240,
                          ),
                        ),
                        SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "https://picsum.photos/800/800",
                            fit: BoxFit.cover,
                            height: 150,
                            width: 240,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _laneHeader() {
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
              'Lane Category',
              style: TextStyles.titleXSmall.copyWith(
                color: const Color(0xFFFBB12C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 14,
        ),
        Text(
          'Lane Name',
          style: TextStyles.title2ExtraLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorStyles.gray900,
          ),
        ),
        Text(
          'Lane Description',
          style: TextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorStyles.gray500,
          ),
        ),
      ],
    );
  }
}

class _NaverMapSection extends StatelessWidget {
  const _NaverMapSection({super.key, required this.mapControllerCompleter});

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

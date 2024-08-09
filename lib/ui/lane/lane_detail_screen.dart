import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';

import '../../themes/color_styles.dart';

// Lane Data 클래스 정의
class LaneData {
  final String category;
  final String name;
  final String description;
  final List<DayData> days;

  LaneData({
    required this.category,
    required this.name,
    required this.description,
    required this.days,
  });
}

class DayData {
  final String date;
  final List<PlaceData> places;

  DayData({required this.date, required this.places});
}

class PlaceData {
  final String name;
  final String region;
  final String category;
  final int likeCount;
  final List<String> imageUrls;

  PlaceData({
    required this.name,
    required this.region,
    required this.category,
    required this.likeCount,
    required this.imageUrls,
  });
}

class LaneDetailScreen extends StatefulWidget {
  final LaneData laneData = LaneData(
    category: '경기도 여행',
    name: '경기도 3일 완전정복 코스',
    description: '경기도의 주요 명소를 3일간 둘러보는 알찬 여행 코스',
    days: [
      DayData(
        date: '2024.12.31',
        places: [
          PlaceData(
            name: '수원화성',
            region: '수원시',
            category: '역사유적',
            likeCount: 1234,
            imageUrls: [
              'https://picsum.photos/seed/suwon1/800/800',
              'https://picsum.photos/seed/suwon2/800/800',
              'https://picsum.photos/seed/suwon3/800/800',
            ],
          ),
          PlaceData(
            name: '행궁동 카페거리',
            region: '수원시',
            category: '카페',
            likeCount: 987,
            imageUrls: [
              'https://picsum.photos/seed/cafe1/800/800',
              'https://picsum.photos/seed/cafe2/800/800',
            ],
          ),
        ],
      ),
      DayData(
        date: '2025.01.01',
        places: [
          PlaceData(
            name: '에버랜드',
            region: '용인시',
            category: '테마파크',
            likeCount: 5678,
            imageUrls: [
              'https://picsum.photos/seed/everland1/800/800',
              'https://picsum.photos/seed/everland2/800/800',
              'https://picsum.photos/seed/everland3/800/800',
            ],
          ),
          PlaceData(
            name: '한국민속촌',
            region: '용인시',
            category: '문화체험',
            likeCount: 3456,
            imageUrls: [
              'https://picsum.photos/seed/folk1/800/800',
              'https://picsum.photos/seed/folk2/800/800',
            ],
          ),
        ],
      ),
      DayData(
        date: '2025.01.02',
        places: [
          PlaceData(
            name: '쁘띠프랑스',
            region: '가평군',
            category: '테마파크',
            likeCount: 2345,
            imageUrls: [
              'https://picsum.photos/seed/france1/800/800',
              'https://picsum.photos/seed/france2/800/800',
            ],
          ),
          PlaceData(
            name: '남이섬',
            region: '가평군',
            category: '자연/관광',
            likeCount: 4567,
            imageUrls: [
              'https://picsum.photos/seed/nami1/800/800',
              'https://picsum.photos/seed/nami2/800/800',
              'https://picsum.photos/seed/nami3/800/800',
            ],
          ),
        ],
      ),
    ],
  );

  LaneDetailScreen({Key? key}) : super(key: key);

  @override
  _LaneDetailScreenState createState() => _LaneDetailScreenState();
}

class _LaneDetailScreenState extends State<LaneDetailScreen> {
  final Completer<NaverMapController> _mapControllerCompleter =
      Completer<NaverMapController>();
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
                onBackPressed: () => Navigator.of(context).pop(),
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
                    onPressed: () {},
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
                    _laneCourseWidget(widget.laneData),
                    _mapViewWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mapViewWidget() {
    return Stack(
      children: [
        _NaverMapSection(mapControllerCompleter: _mapControllerCompleter),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomSheetLikeView(),
        ),
      ],
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
                        children: widget.laneData.days[_selectedDayIndex].places
                            .map(
                                (place) => _placeDetailItemInBottomSheet(place))
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
      shape: RoundedRectangleBorder(
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
                    itemCount: widget.laneData.days.length,
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

  // _placeDetailItemInBottomSheet, _laneCourseWidget, _lanePlace, _laneHeader 메서드들은 이전과 동일

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
              widget.laneData.category,
              style: TextStyles.titleXSmall.copyWith(
                color: const Color(0xFFFBB12C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 14),
        Text(
          widget.laneData.name,
          style: TextStyles.title2ExtraLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorStyles.gray900,
          ),
        ),
        Text(
          widget.laneData.description,
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

  Widget _lanePlace(PlaceData place) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
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
                    color: Color(0xFFFBB12C),
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name,
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
                            Text(place.region,
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray500,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(width: 4),
                            Text("|",
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray300,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(width: 4),
                            Text(place.category,
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
                      Text(place.likeCount.toString(),
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
                      children: place.imageUrls
                          .map((url) => Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: 240,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeDetailItemInBottomSheet(PlaceData place) {
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
                  place.imageUrls.first,
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: TextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.gray800),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${place.region} | ${place.category}",
                              style: TextStyles.bodyMedium.copyWith(
                                  color: ColorStyles.gray500,
                                  fontWeight: FontWeight.w400),
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
                          Text(place.likeCount.toString(),
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
    );
  }

  Widget _laneCourseWidget(LaneData laneData) {
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
                children: laneData.days
                    .expand((day) => [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                            child: Row(children: [
                              Text(
                                "Day ${laneData.days.indexOf(day) + 1}",
                                style: TextStyles.titleLarge.copyWith(
                                    color: ColorStyles.gray900,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                day.date,
                                style: TextStyles.bodyLarge.copyWith(
                                    color: ColorStyles.gray500,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                          ),
                          ...day.places
                              .expand((place) => [
                                    _lanePlace(place),
                                    if (day.places.last != place)
                                      _laneDivider(),
                                  ])
                              .toList(),
                        ])
                    .toList(),
              ),
            ),
          ),
        );
      },
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

/*
class LaneDetailScreen extends StatelessWidget {
  LaneDetailScreen({super.key});

  final Completer<NaverMapController> _mapControllerCompleter =
      Completer<NaverMapController>();

  final LaneData laneData = LaneData(
    category: '경기도 여행',
    name: '경기도 3일 완전정복 코스',
    description: '경기도의 주요 명소를 3일간 둘러보는 알찬 여행 코스',
    days: [
      DayData(
        date: '2024.12.31',
        places: [
          PlaceData(
            name: '수원화성',
            region: '수원시',
            category: '역사유적',
            likeCount: 1234,
            imageUrls: [
              'https://picsum.photos/seed/suwon1/800/800',
              'https://picsum.photos/seed/suwon2/800/800',
              'https://picsum.photos/seed/suwon3/800/800',
            ],
          ),
          PlaceData(
            name: '행궁동 카페거리',
            region: '수원시',
            category: '카페',
            likeCount: 987,
            imageUrls: [
              'https://picsum.photos/seed/cafe1/800/800',
              'https://picsum.photos/seed/cafe2/800/800',
            ],
          ),
        ],
      ),
      DayData(
        date: '2025.01.01',
        places: [
          PlaceData(
            name: '에버랜드',
            region: '용인시',
            category: '테마파크',
            likeCount: 5678,
            imageUrls: [
              'https://picsum.photos/seed/everland1/800/800',
              'https://picsum.photos/seed/everland2/800/800',
              'https://picsum.photos/seed/everland3/800/800',
            ],
          ),
          PlaceData(
            name: '한국민속촌',
            region: '용인시',
            category: '문화체험',
            likeCount: 3456,
            imageUrls: [
              'https://picsum.photos/seed/folk1/800/800',
              'https://picsum.photos/seed/folk2/800/800',
            ],
          ),
        ],
      ),
      DayData(
        date: '2025.01.02',
        places: [
          PlaceData(
            name: '쁘띠프랑스',
            region: '가평군',
            category: '테마파크',
            likeCount: 2345,
            imageUrls: [
              'https://picsum.photos/seed/france1/800/800',
              'https://picsum.photos/seed/france2/800/800',
            ],
          ),
          PlaceData(
            name: '남이섬',
            region: '가평군',
            category: '자연/관광',
            likeCount: 4567,
            imageUrls: [
              'https://picsum.photos/seed/nami1/800/800',
              'https://picsum.photos/seed/nami2/800/800',
              'https://picsum.photos/seed/nami3/800/800',
            ],
          ),
        ],
      ),
    ],
  );

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
                child: _laneHeader(laneData),
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
                    _laneCourseWidget(laneData),
                    Stack(
                      children: [
                        _NaverMapSection(
                            mapControllerCompleter: _mapControllerCompleter),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _buildBottomSheetLikeView(laneData),
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

  Widget _buildBottomSheetLikeView(LaneData laneData) {
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
                              "Day ${laneData.days.indexOf(laneData.days.first) + 1}",
                              style: TextStyles.titleMedium.copyWith(
                                  color: ColorStyles.gray900,
                                  fontWeight: FontWeight.w600),
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
                          children: laneData.days.first.places
                              .map((place) =>
                                  _placeDetailItemInBottomSheet(place))
                              .toList(),
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

  Widget _placeDetailItemInBottomSheet(PlaceData place) {
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
                  place.imageUrls.first,
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: TextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.gray800),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${place.region} | ${place.category}",
                              style: TextStyles.bodyMedium.copyWith(
                                  color: ColorStyles.gray500,
                                  fontWeight: FontWeight.w400),
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
                          Text(place.likeCount.toString(),
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
    );
  }

  Widget _laneCourseWidget(LaneData laneData) {
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
                children: laneData.days
                    .expand((day) => [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                            child: Row(children: [
                              Text(
                                "Day ${laneData.days.indexOf(day) + 1}",
                                style: TextStyles.titleLarge.copyWith(
                                    color: ColorStyles.gray900,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                day.date,
                                style: TextStyles.bodyLarge.copyWith(
                                    color: ColorStyles.gray500,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                          ),
                          ...day.places
                              .expand((place) => [
                                    _lanePlace(place),
                                    if (day.places.last != place)
                                      _laneDivider(),
                                  ])
                              .toList(),
                        ])
                    .toList(),
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

  Widget _lanePlace(PlaceData place) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
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
                    color: Color(0xFFFBB12C),
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name,
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
                            Text(place.region,
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray500,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(width: 4),
                            Text("|",
                                style: TextStyles.bodyMedium.copyWith(
                                    color: ColorStyles.gray300,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(width: 4),
                            Text(place.category,
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
                      Text(place.likeCount.toString(),
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
                      children: place.imageUrls
                          .map((url) => Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: 240,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _laneHeader(LaneData laneData) {
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
              laneData.category,
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
          laneData.name,
          style: TextStyles.title2ExtraLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorStyles.gray900,
          ),
        ),
        Text(
          laneData.description,
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
*/

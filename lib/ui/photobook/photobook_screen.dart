import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/photobook/photobook_list_item.dart';

class PhotobookScreen extends StatefulWidget {
  const PhotobookScreen({super.key});

  @override
  _PhotobookScreenState createState() => _PhotobookScreenState();
}

class _PhotobookScreenState extends State<PhotobookScreen> with RouteAware {
  final Completer<NaverMapController> _mapControllerCompleter = Completer<NaverMapController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });
  }

  void _showBottomSheet() {
    final photobooks = List<Map<String, String>>.generate(10, (index) => {
        'category': '힐링',
        'title': '이게낭만이지선',
        'period': '24. 05. 12 ~ 24. 05. 21',
      }
    );

    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: photobooks.length,
                  itemBuilder: (context, index) {
                    final photobook = photobooks[index];
                    return PhotobookListItem(
                      category: photobook['category']!,
                      title: photobook['title']!,
                      period: photobook['period']!,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const _TabBarSection(),
                Expanded(
                  child: TabBarView(
                    children: [
                      _NaverMapSection(mapControllerCompleter: _mapControllerCompleter),
                      _NaverMapSection(mapControllerCompleter: _mapControllerCompleter),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).push("/photobook/add");
              },
              child: SvgPicture.asset(
                "assets/icons/ic_add_photo.svg",
                width: 52,
                height: 52,
                fit: BoxFit.fill,
              ),
            )
          ),

          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  _showBottomSheet();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorStyles.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "목록 열기",
                    style: TextStyles.titleSmall.copyWith(
                      color: ColorStyles.grayWhite,
                    ),
                  ),
                )
              ),
            )
          ),

        ]
      ),
    );
  }
}

class _TabBarSection extends StatelessWidget {
  const _TabBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorStyles.gray900,
            width: 1,
          ),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(
          child: Text(
            "포토북",
            style: TextStyle(
              color: ColorStyles.gray900,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        Tab(
          child: Text(
            "포토티켓",
            style: TextStyle(
              color: ColorStyles.gray900,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
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
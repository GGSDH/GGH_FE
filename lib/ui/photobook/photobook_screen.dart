import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
            minChildSize: 0.5,
            maxChildSize: 0.8,
            snap: true,
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
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const _TabBarSection(),
                Expanded(
                  child: TabBarView(
                    children: [
                      _PhotobookSection(
                        mapControllerCompleter: _mapControllerCompleter,
                        onAddPhotobook: () {
                          GoRouter.of(context).go('/photobook/add');
                        },
                        showPhotobookList: _showBottomSheet,
                      ),
                      _PhotoTicketSection(),
                    ],
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}

class _TabBarSection extends StatelessWidget {
  const _TabBarSection();

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: const BoxDecoration(
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
            style: TextStyles.titleLarge.copyWith(
              color: ColorStyles.gray900,
            ),
          ),
        ),
        Tab(
          child: Text(
            "포토티켓",
            style: TextStyles.titleLarge.copyWith(
              color: ColorStyles.gray900,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotobookSection extends StatelessWidget {
  const _PhotobookSection({
    required this.mapControllerCompleter,
    required this.onAddPhotobook,
    required this.showPhotobookList,
  });

  final Completer<NaverMapController> mapControllerCompleter;
  final VoidCallback onAddPhotobook;
  final VoidCallback showPhotobookList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: false,
            rotationGesturesEnable: true,
            scrollGesturesEnable: true,
            zoomGesturesEnable: true,
          ),
          onMapReady: (controller) {
            mapControllerCompleter.complete(controller);
          },
          forceGesture: true,
        ),
        Positioned(
          bottom: 20,
          right: 10,
          child: GestureDetector(
            onTap: onAddPhotobook,
            child: SvgPicture.asset(
              "assets/icons/ic_add_photo.svg",
              width: 52,
              height: 52,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: showPhotobookList,
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
                ),
              ),
            )
        ),
      ]
    );
  }
}

class _PhotoTicketSection extends StatelessWidget {
  _PhotoTicketSection();

  final PageController _controller = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300, // 높이 설정
        child: PageView.builder(
          controller: _controller,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // 카드 간 간격 설정
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.blue[(index + 1) * 100],
                ),
                child: Center(
                  child: Text(
                    'Page $index',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
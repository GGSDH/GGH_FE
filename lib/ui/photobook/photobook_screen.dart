import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../themes/color_styles.dart';

class PhotobookScreen extends StatelessWidget {
  PhotobookScreen({super.key});

  final Completer<NaverMapController> _mapControllerCompleter = Completer<NaverMapController>();

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

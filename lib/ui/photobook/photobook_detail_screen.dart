import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';

import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_image_plaeholder.dart';

class PhotobookDetailScreen extends StatefulWidget {
  @override
  _PhotobookDetailScreenState createState() => _PhotobookDetailScreenState();
}

class _PhotobookDetailScreenState extends State<PhotobookDetailScreen> {
  int currentPage = 0;
  final int pageCount = 5;
  late double baseCardWidth;
  late double baseCardHeight;
  double scaleFactor = 0.9; // 각 페이지가 멀어질수록 크기 줄어드는 비율
  double visiblePartHeight = 20.0; // 겹치지 않는 부분의 높이
  double swipeOffset = 0.0;
  bool isSwiping = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    baseCardWidth = screenWidth * 0.9;
    baseCardHeight = baseCardWidth * 1.4;

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
            children: [
              AppActionBar(
                rightText: '',
                onBackPressed: () {
                  GoRouter.of(context).pop();
                },
                menuItems: [
                  ActionBarMenuItem(
                    icon: SvgPicture.asset(
                      "assets/icons/ic_map.svg",
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () => print("map clicked")
                  )
                ]
              ),

              const Text(
                "의정부 탐방",
                style: TextStyles.title2ExtraLarge
              ),
              const SizedBox(height: 4),
              Text(
                "24.05.12 ~ 24.05.17",
                style: TextStyles.bodyLarge.copyWith(
                  color: ColorStyles.gray500
                )
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: baseCardWidth,
                height: baseCardHeight + 40,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double stackHeight = constraints.maxHeight;
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        for (int i = pageCount - 1; i >= currentPage; i--)
                          _buildCard(i, stackHeight), // 현재 페이지부터 페이지들을 역순으로 쌓음
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  GoRouter.of(context).push("${Routes.photobook.path}/${Routes.addPhotobook.path}");
                },
                child: SvgPicture.asset(
                  "assets/icons/ic_add_photo.svg",
                  width: 52,
                  height: 52,
                  fit: BoxFit.fill,
                ),
              ),
            ),
      ],
        )
      ),
    );
  }

  Widget _buildCard(int index, double stackHeight) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: calculateBottomOffset(index, stackHeight) + (index == currentPage ? swipeOffset : 0),
      width: calculateCardWidth(index),
      height: calculateCardHeight(index),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            swipeOffset += details.delta.dy; // 스와이프 방향으로 페이지 이동
          });
        },
        onVerticalDragEnd: (details) => _onVerticalDragEnd(details),
        child: Opacity(
          opacity: calculateOpacity(index),
          child: Page(
            day: index + 1,
            imageUrl: 'https://i.namu.wiki/i/4quYhHq2ToyXcDJ8eIQ7xxDUFIVhmdinYplLfVROQJS9oZDrswV63wfIR_0rZ_aaITRTwuy3qWVmbrTi_sslCzebO9oZW8sBTbP2mYz7p34RO6gLJjwCYOwvxLQIw8lDqNrgomn8KY1OHZvXMjrqVA.webp',
            dateTime: '8월 5일',
            name: '의정부 부대찌개',
            location: '의정부',
          ),
        ),
      ),
    );
  }

  double calculateBottomOffset(int index, double stackHeight) {
    double offsetFromCenter = (index - currentPage).toDouble();
    return 40 - offsetFromCenter * visiblePartHeight;
  }

  double calculateCardWidth(int index) {
    double scale = 1 - ((index - currentPage).abs() * (1 - scaleFactor));
    return baseCardWidth * scale;
  }

  double calculateCardHeight(int index) {
    double scale = 1 - ((index - currentPage).abs() * (1 - scaleFactor));
    return baseCardHeight * scale;
  }

  double calculateOpacity(int index) {
    double maxOpacityDecrease = 0.5; // 가장 멀리 있는 페이지의 최소 투명도
    double opacity = 1 - ((index - currentPage).abs() * maxOpacityDecrease);
    if ((index - currentPage).abs() > 2) return 0;
    return opacity.clamp(0.5, 1.0);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! < 0 && currentPage < pageCount - 1) {
      // 아래 -> 위로 스와이프 (다음 페이지로 이동)
      setState(() {
        swipeOffset = MediaQuery.of(context).size.height; // 페이지를 아래로 이동
        isSwiping = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          currentPage++;
          swipeOffset = 0.0; // 초기화
          isSwiping = false;
        });
      });
    } else if (details.primaryVelocity! > 0 && currentPage > 0) {
      // 위 -> 아래로 스와이프 (이전 페이지로 이동)
      setState(() {
        swipeOffset = -MediaQuery.of(context).size.height; // 페이지를 위로 이동
        isSwiping = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          currentPage--;
          swipeOffset = 0.0; // 초기화
          isSwiping = false;
        });
      });
    } else {
      setState(() {
        swipeOffset = 0.0; // 스와이프 취소 시 초기화
      });
    }
  }
}

class Page extends StatelessWidget {
  final int day;
  final String imageUrl;
  final String dateTime;
  final String name;
  final String location;

  const Page({
    super.key,
    required this.day,
    required this.imageUrl,
    required this.dateTime,
    required this.name,

    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const AppImagePlaceholder(width: double.infinity, height: double.infinity),
            errorWidget: (context, url, error) => const AppImagePlaceholder(width: double.infinity, height: double.infinity),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAY$day',
                  style: TextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateTime,
                  style: TextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
                const Spacer(),
                Text(
                  name,
                  style: TextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/ic_map_pin.svg",
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      location,
                      style: TextStyles.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';


class RestaurantData {
  final String title;
  final String description;
  final int likeCount;
  final String region;
  final String type;
  final String imagePath;
  final bool isLiked;

  RestaurantData({
    required this.title,
    required this.description,
    required this.likeCount,
    required this.region,
    required this.type,
    required this.imagePath,
    required this.isLiked,
  });
}

class LocalRestaurantsScreen extends StatelessWidget {
  LocalRestaurantsScreen({super.key});

  final List<RestaurantData> restaurants = [
    RestaurantData(
      title: "맛있는 김밥",
      description: "30년 전통의 김밥 전문점",
      region: "수원",
      type: "분식",
      likeCount: 128,
      isLiked: true, imagePath: 'https://picsum.photos/seed/gimbap/500/500',
    ),
    RestaurantData(
      title: "왕갈비",
      description: "참숯으로 구워내는 특급 갈비",
      region: "용인",
      type: "한식",
      likeCount: 256,
      isLiked: false, imagePath: 'https://picsum.photos/seed/galbi/500/500',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            AppActionBar(
              rightText: "",
              onBackPressed: () => Navigator.pop(context),
              menuItems: const [],
              title: "지역 맛집",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('전체',
                          style: TextStyles.bodyMedium.copyWith(
                              color: ColorStyles.gray700,
                              fontWeight: FontWeight.w400)),
                      const SizedBox(width: 4),
                      Text('${restaurants.length}개',
                          style: TextStyles.titleSmall.copyWith(
                            color: ColorStyles.gray900,
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '지역',
                          style: TextStyles.bodyMedium.copyWith(
                              color: ColorStyles.gray900,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(width: 12),
                        SvgPicture.asset(
                          "assets/icons/ic_chevron_right.svg",
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RestaurantItemList(items: restaurants),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantItemList extends StatelessWidget {
  final List<RestaurantData> items;

  const RestaurantItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return RestaurantListItem(item);
      },
    );
  }

  Container RestaurantListItem(RestaurantData item) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  item.title,
                  style: TextStyles.titleLarge.copyWith(
                    color: ColorStyles.gray900,
                  ),
                ),
                Text(
                  item.description,
                  style: TextStyles.bodyLarge.copyWith(
                    color: ColorStyles.gray800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SvgPicture.asset(
                      item.isLiked
                          ? "assets/icons/ic_heart_filled.svg"
                          : "assets/icons/ic_heart.svg",
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 1),
                    Text(
                      item.likeCount.toString(),
                      style: TextStyles.bodyXSmall.copyWith(
                          color: ColorStyles.gray500,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 4),
                    Text("|",
                        style: TextStyles.bodyMedium.copyWith(
                            color: ColorStyles.gray300,
                            fontWeight: FontWeight.w400)),
                    const SizedBox(width: 4),
                    Text(
                      item.region,
                      style: TextStyles.bodyMedium.copyWith(
                          color: ColorStyles.gray500,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 4),
                    Text("|",
                        style: TextStyles.bodyMedium.copyWith(
                            color: ColorStyles.gray300,
                            fontWeight: FontWeight.w400)),
                    const SizedBox(width: 4),
                    Text(
                      item.type,
                      style: TextStyles.bodyMedium.copyWith(
                          color: ColorStyles.gray500,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  item.imagePath,
                  width: 104,
                  height: 104,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: SvgPicture.asset(
                  item.isLiked
                      ? "assets/icons/ic_heart_filled.svg"
                      : "assets/icons/ic_heart_white.svg",
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
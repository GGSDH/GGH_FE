import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

import '../app/app_image_plaeholder.dart';

class LaneListItem extends StatelessWidget {
  String category;
  String title;
  String description;
  String image;
  String period;
  int likeCount;
  bool isLiked;

  LaneListItem({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.image,
    required this.period,
    required this.likeCount,
    required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  decoration: BoxDecoration(
                    color: ColorStyles.primaryLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category,
                    style: TextStyles.labelMedium.copyWith(
                      color: ColorStyles.primary,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: TextStyles.titleLarge.copyWith(
                    color: ColorStyles.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  description,
                  style: TextStyles.bodyLarge.copyWith(
                    color: ColorStyles.gray800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "$period | ",
                      style: TextStyles.bodyMedium.copyWith(
                        color: ColorStyles.gray500,
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/ic_train.svg",
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      "$likeCount명 탑승중",
                      style: TextStyles.bodyMedium.copyWith(
                        color: ColorStyles.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => const AppImagePlaceholder(width: 200, height: 145),
                  errorWidget: (context, url, error) => const AppImagePlaceholder(width: 200, height: 145),
                  width: 104,
                  height: 104,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: SvgPicture.asset(
                  isLiked
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

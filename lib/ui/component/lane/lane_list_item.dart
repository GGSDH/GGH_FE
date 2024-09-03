import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

import '../app/app_image_plaeholder.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LaneListItem extends StatelessWidget {
  final String category;
  final String title;
  final String description;
  final String image;
  final String period;
  final int likeCount;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onUnlike;
  final VoidCallback onClick;

  const LaneListItem({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.image,
    required this.period,
    required this.likeCount,
    required this.isLiked,
    required this.onLike,
    required this.onUnlike,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 전체 컨테이너를 GestureDetector로 감싸기
      onTap: onClick, // 클릭 이벤트 추가
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
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
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyles.titleLarge.copyWith(
                      color: ColorStyles.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description.isNotEmpty) ...[
                    Text(
                      description,
                      style: TextStyles.bodyLarge.copyWith(
                        color: ColorStyles.gray800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],
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
                    placeholder: (context, url) =>
                        const AppImagePlaceholder(width: 200, height: 145),
                    errorWidget: (context, url, error) =>
                        const AppImagePlaceholder(width: 200, height: 145),
                    width: 104,
                    height: 104,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: isLiked ? onUnlike : onLike,
                    child: SvgPicture.asset(
                      isLiked
                          ? "assets/icons/ic_heart_filled.svg"
                          : "assets/icons/ic_heart_white.svg",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

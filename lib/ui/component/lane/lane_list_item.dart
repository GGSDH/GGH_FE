import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

class LaneListItem extends StatelessWidget {
  String category;
  String title;
  String description;
  String period;
  int likeCount;
  bool isLiked;

  LaneListItem({
    super.key,
    required this.category,
    required this.title,
    required this.description,
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
          Column(
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
              ),
              Text(
                description,
                style: TextStyles.bodyLarge.copyWith(
                  color: ColorStyles.gray800,
                ),
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
          const Spacer(),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  "http://tong.visitkorea.or.kr/cms/resource/48/2739048_image2_1.JPG",
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

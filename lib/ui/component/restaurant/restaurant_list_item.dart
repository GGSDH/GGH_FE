import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

class RestaurantListItem extends StatelessWidget {
  final String name;
  final double rating;
  final String location;
  final String category;
  final bool isLiked;

  const RestaurantListItem(
      {super.key,
      required this.name,
      required this.rating,
      required this.location,
      required this.category,
      required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        "assets/images/img_dummy_place.png",
                        width: 200,
                        height: 145,
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
                const SizedBox(height: 12),
                Text(
                  name,
                  style: TextStyles.titleMedium.copyWith(
                    color: ColorStyles.gray900,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset("assets/icons/ic_star.svg",
                        width: 18, height: 18),
                    const SizedBox(width: 2),
                    Text(
                      "$rating | $location | $category",
                      style: TextStyles.bodyMedium.copyWith(
                        color: ColorStyles.gray500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}

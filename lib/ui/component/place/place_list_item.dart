import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import '../app/app_image_plaeholder.dart';

class PlaceListItem extends StatelessWidget {
  final String name;
  final String description;
  final String image;
  final int likeCount;
  final bool likedByMe;
  final String sigunguValue;
  final VoidCallback onLike;
  final VoidCallback onUnlike;

  const PlaceListItem({
    super.key,
    required this.name,
    required this.description,
    required this.image,
    required this.likeCount,
    required this.likedByMe,
    required this.sigunguValue,
    required this.onLike,
    required this.onUnlike,
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
                const SizedBox(height: 12),
                Text(
                  name,
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: likedByMe ? onUnlike : onLike,
                      child: SvgPicture.asset(
                        likedByMe
                            ? "assets/icons/ic_heart_filled.svg"
                            : "assets/icons/ic_heart.svg",
                        width: 18,
                        height: 18,
                      ),
                    ),
                    const SizedBox(width: 1),
                    Text(
                      likeCount.toString(),
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
                      sigunguValue,
                      style: TextStyles.bodyMedium.copyWith(
                          color: ColorStyles.gray500,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 4),
                    Text("|",
                        style: TextStyles.bodyMedium.copyWith(
                            color: ColorStyles.gray300,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) =>
                      const AppImagePlaceholder(width: 104, height: 104),
                  errorWidget: (context, url, error) =>
                      const AppImagePlaceholder(width: 104, height: 104),
                  width: 104,
                  height: 104,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: likedByMe ? onUnlike : onLike,
                  child: SvgPicture.asset(
                    likedByMe
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
    );
  }
}

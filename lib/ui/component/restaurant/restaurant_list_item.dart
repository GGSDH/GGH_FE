import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_image_plaeholder.dart';

class RestaurantListItem extends StatelessWidget {
  final String name;
  final String? image;
  final int likeCount;
  final String location;
  final bool isLiked;
  final VoidCallback onClick;
  final VoidCallback onLike;
  final VoidCallback onUnlike;

  const RestaurantListItem({
    super.key,
    required this.name,
    this.image,
    required this.likeCount,
    required this.location,
    required this.isLiked,
    required this.onClick,
    required this.onLike,
    required this.onUnlike,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
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
                        child: CachedNetworkImage(
                          imageUrl: image ?? "",
                          placeholder: (context, url) =>
                              const AppImagePlaceholder(width: 200, height: 145),
                          errorWidget: (context, url, error) =>
                              const AppImagePlaceholder(width: 200, height: 145),
                          width: 200,
                          height: 145,
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
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 200,
                    child: Text(
                      name,
                      style: TextStyles.titleMedium.copyWith(
                        color: ColorStyles.gray900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        isLiked
                            ? "assets/icons/ic_heart_filled.svg"
                            : "assets/icons/ic_heart_white.svg",
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          isLiked ? ColorStyles.error
                            : ColorStyles.gray400, BlendMode.srcIn)
                      ),
                      const SizedBox(width: 2),
                      Text(
                        "$likeCount | $location",
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
      ),
    );
  }
}

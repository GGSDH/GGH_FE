import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';
import '../app/app_image_plaeholder.dart';

class PopularDestinationListItem extends StatelessWidget {
  final int rank;
  final String name;
  final String? image;
  final String location;
  final String category;

  const PopularDestinationListItem({
    super.key,
    required this.rank,
    required this.name,
    required this.image,
    required this.location,
    required this.category,
  });

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
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: image ?? "",
                        placeholder: (context, url) => const AppImagePlaceholder(width: 200, height: 145),
                        errorWidget: (context, url, error) => const AppImagePlaceholder(width: 200, height: 145),
                        width: 145,
                        height: 145,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: ColorStyles.gray800,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                        ),
                        child: Center(
                          child: Text("$rank",
                              style: TextStyles.titleXSmall
                                  .copyWith(color: ColorStyles.grayWhite)),
                        ))
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 145,
                  child: Text(
                    name,
                    style: TextStyles.titleMedium.copyWith(
                      color: ColorStyles.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 145,
                  child: Text(
                    "$location | $category",
                    style: TextStyles.bodyMedium.copyWith(
                      color: ColorStyles.gray500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
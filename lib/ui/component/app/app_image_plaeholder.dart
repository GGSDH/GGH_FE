import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../themes/color_styles.dart';

class AppImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const AppImagePlaceholder({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: ColorStyles.gray200, // Light gray background
      child: Center(
        child: SvgPicture.asset("assets/icons/ic_image_placeholder.svg"),
      ),
    );
  }
}

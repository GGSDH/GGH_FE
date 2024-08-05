import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';

class AddPhotobookLoadingScreen extends StatelessWidget {
  const AddPhotobookLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "소중한 추억이 담긴\n포토북을 생성중이예요",
              style: TextStyles.title2ExtraLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 100),

            SvgPicture.asset(
              "assets/icons/img_add_photobook_loading_illust.svg",
              fit: BoxFit.fill,
            )
          ],
        ),
      ),
    );
  }
}
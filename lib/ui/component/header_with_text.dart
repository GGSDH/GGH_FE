import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

class HeaderWithText extends StatelessWidget {
  final String rightText;
  final VoidCallback onBackPressed;

  const HeaderWithText(
      {super.key, required this.rightText, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/ic_arrow_back.svg",
              width: 24,
              height: 24,
            ),
            onPressed: onBackPressed,
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                rightText,
                style:
                    TextStyles.bodyLarge.copyWith(color: ColorStyles.gray400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

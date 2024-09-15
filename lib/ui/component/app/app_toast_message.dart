import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';

class AppToastMessage extends StatelessWidget {
  final String message;

  const AppToastMessage({
    super.key,
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 24, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: ColorStyles.gray700,
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/ic_error.svg",
            width: 24,
            height: 24
          ),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyles.titleMedium.copyWith(
              color: ColorStyles.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
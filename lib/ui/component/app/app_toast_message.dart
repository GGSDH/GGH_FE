import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';

class AppToastMessage extends StatelessWidget {
  final String message;
  final double bottomPadding;

  const AppToastMessage({
    super.key,
    required this.message,
    this.bottomPadding = 80
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 24, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                color: ColorStyles.gray400,
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
              Expanded(
                child: Text(
                  message,
                  style: TextStyles.titleMedium.copyWith(
                    color: ColorStyles.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: bottomPadding)
      ],
    );
  }
}
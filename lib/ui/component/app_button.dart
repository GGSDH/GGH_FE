import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final VoidCallback? onIllegalPressed;
  final bool isEnabled;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.onIllegalPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : onIllegalPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isEnabled ? ColorStyles.primary : ColorStyles.gray100,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            text,
            style: TextStyles.titleMedium.copyWith(
              color: isEnabled ? Colors.white : ColorStyles.gray500,
            ),
          ),
        ),
      ),
    );
  }
}

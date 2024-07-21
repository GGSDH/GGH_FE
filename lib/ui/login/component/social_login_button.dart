import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../themes/text_styles.dart';

enum SocialLoginType {
  APPLE, KAKAO
}

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType loginType;
  final VoidCallback onClick;

  const SocialLoginButton({
    super.key,
    required this.loginType,
    required this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 16
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                _getButtonIcon(),
                width: 24,
                height: 24,
              ),

              const SizedBox(width: 14),

              Text(
                _getButtonText(),
                style: TextStyles.titleMedium.copyWith(
                  color: _getButtonTextColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (loginType) {
      case SocialLoginType.APPLE:
        return "Apple로 시작하기";
      case SocialLoginType.KAKAO:
        return "카카오로 3초만에 시작하기";
    }
  }

  Color _getButtonColor() {
    switch (loginType) {
      case SocialLoginType.APPLE:
        return Colors.black;
      case SocialLoginType.KAKAO:
        return const Color(0xFFFBE400);
    }
  }

  Color _getButtonTextColor() {
    switch (loginType) {
      case SocialLoginType.APPLE:
        return const Color(0xFFFFFFFF);
      case SocialLoginType.KAKAO:
        return const Color(0xFF3E1A1D);
    }
  }

  String _getButtonIcon() {
    switch (loginType) {
      case SocialLoginType.APPLE:
        return "assets/icons/ic_apple.svg";
      case SocialLoginType.KAKAO:
        return "assets/icons/ic_kakao.svg";
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../themes/text_styles.dart';
import '../component/app_button.dart';

class OnboardingCompleteScreen extends StatelessWidget {

  const OnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 192),

        SvgPicture.asset(
          'assets/icons/ic_onboarding_complete.svg',
          width: 150,
          height: 150,
        ),

        const SizedBox(height: 24),

        const Text(
          "회원가입 완료",
          style: TextStyles.title2ExtraLarge
        ),

        const SizedBox(height: 14),

        const Text(
          "경기선에 탑승하셨군요!\n여러분만의 노선을 만들어 보세요.",
          style: TextStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),

        const Spacer(),

        Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            width: double.infinity,
            child: AppButton(
              text: "다음",
              onPressed: () { GoRouter.of(context).go('/home'); },
              isEnabled: true,
              onIllegalPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
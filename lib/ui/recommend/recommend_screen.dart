import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/component/app/app_button.dart';

import '../../routes.dart';

class RecommendScreen extends StatelessWidget {
  const RecommendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 60),
          const Text(
            'AI 노선 추천',
            style: TextStyles.displaySmall,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Text(
              "회원님이 취향을 반영한 노선을\nAI가 직접 추천해 드려요!",
              style: TextStyles.bodyLarge.copyWith(
                  color: ColorStyles.gray600, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SvgPicture.asset(
              "assets/icons/img_bg_recommend.svg",
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: AppButton(
                text: "AI 노선 추천 받기",
                onPressed: () => {
                  GoRouter.of(context).push(
                    "${Routes.recommend.path}/${Routes.recommendSelectRegion.path}",
                  )
                }),
          ),
        ],
      ),
    );
  }
}

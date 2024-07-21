import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../themes/text_styles.dart';

class PageContent extends StatelessWidget {
  final int pageIndex;

  const PageContent({
    super.key,
    required this.pageIndex
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 96),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getPageText(),
                style: TextStyles.title2ExtraLarge
              ),

              if (pageIndex == 1) ...[
                const SizedBox(height: 10),
                Text(
                  "*여행지: 숙박/관광지/음식점",
                  style: TextStyles.titleSmall.copyWith(
                    color: const Color(0xFF898989)
                  ),
                ),
              ]
            ],
          ),
        ),

        SizedBox(height: pageIndex == 1 ? 62 : 75),

        AspectRatio(
          aspectRatio: 1.572,
          child: SvgPicture.asset(
            _getPageImage(),
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        )
      ]
    );
  }

  String _getPageText() {
    if (pageIndex == 0) {
      return "탑승하세요!\n새로운 경기여행의 시작,\n경기선 출발합니다.";
    } else if (pageIndex == 1) {
      return "경기행에서는\n여행코스가 노선,\n역이 여행지를 뜻해요.";
    } else {
      return "경기에서의 추억을\n포토티켓으로\n기록해 보세요.";
    }
  }

  String _getPageImage() {
    if (pageIndex == 0) {
      return "assets/icons/ic_onboarding_one.svg";
    } else if (pageIndex == 1) {
      return "assets/icons/ic_onboarding_two.svg";
    } else {
      return "assets/icons/ic_onboarding_three.svg";
    }
  }
}
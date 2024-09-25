import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';

import '../../../routes.dart';
import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';
import '../../component/app/app_button.dart';

class AddPhotobookScreen extends StatelessWidget {
  const AddPhotobookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            AppActionBar(
              onBackPressed: () {
                GoRouter.of(context).pop();
              },
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "소중한 추억,\n포토북으로 만들어 보세요!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: ColorStyles.gray900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("경기 지역의 여행만 포토북 생성이 가능해요.",
                        style: TextStyles.bodyLarge
                            .copyWith(color: ColorStyles.gray600)),
                  ),


                  const SizedBox(height: 40),

                  SvgPicture.asset(
                    "assets/icons/img_add_photobook_illust.svg",
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 33),

            Padding(
              padding: const EdgeInsets.all(14),
              child: AppButton(
                text: "포토북 만들기",
                onPressed: () {
                  GoRouter.of(context).push("${Routes.photobook.path}/${Routes.addPhotobook.path}/${Routes.addPhotobookSelectPeriod.path}");
                },
                isEnabled: true,
                onIllegalPressed: () {},
              ),
            ),
          ]
        ),
      ),
    );
  }
}
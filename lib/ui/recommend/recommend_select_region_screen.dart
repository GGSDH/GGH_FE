import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/app/app_button.dart';

import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';

class RecommendSelectRegionScreen extends StatefulWidget {

  const RecommendSelectRegionScreen({super.key});

  @override
  RecommendSelectRegionState createState() => RecommendSelectRegionState();
}

class RecommendSelectRegionState extends State<RecommendSelectRegionScreen> {
  final Set<SigunguCode> _selectedAreas = {};

  final chips = SigunguCode.values.sublist(0, SigunguCode.values.length - 1);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            AppActionBar(
              onBackPressed: () => GoRouter.of(context).pop(),
              rightText: '1/3',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,// Padding을 Expanded 바깥으로 이동
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "어디를 여행하고 싶으신가요?",
                        style: TextStyles.headlineXSmall.copyWith(
                          color: ColorStyles.gray900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "가고 싶은 모든 여행지를 선택해 주세요.",
                        style: TextStyles.bodyLarge.copyWith(
                          color: ColorStyles.gray600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: chips.map((chip) => areaChip(chip)).toList(),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: AppButton(
                text: '다음',
                onPressed: () {
                  GoRouter.of(context).push(
                    Uri(
                      path: "${Routes.recommend.path}/${Routes.recommendSelectPeriod.path}",
                      queryParameters: {
                        "selectedSigunguCodes": _selectedAreas.map((e) => SigunguCode.toJson(e)).join(","),
                      }
                    ).toString()
                  );
                },
                isEnabled: _selectedAreas.isNotEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget areaChip(SigunguCode code) {
    final isSelected = _selectedAreas.contains(code);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAreas.remove(code);
          } else {
            _selectedAreas.add(code);
          }
        });
      },
      child: Chip(
        padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8
        ),
        shape : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(
            color: isSelected ? Colors.transparent : ColorStyles.gray200,
          ),
        ),
        label: Text(
            code.value,
            style: TextStyles.titleMedium.copyWith(
                color: isSelected ? Colors.white : ColorStyles.gray600
            )
        ),
        backgroundColor: isSelected ? ColorStyles.gray800 : ColorStyles.grayWhite,
      ),
    );
  }
}


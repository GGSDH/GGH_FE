import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/route_extension.dart';

import '../../data/models/trip_theme.dart';
import '../../routes.dart';
import '../../themes/text_styles.dart';
import '../../util/toast_util.dart';
import '../component/app/app_action_bar.dart';
import '../component/app/app_button.dart';
import '../onboarding/component/select_grid.dart';

class RecommendSelectThemeScreen extends StatefulWidget {
  final List<SigunguCode> sigunguCodes;
  final int days;

  const RecommendSelectThemeScreen({
    super.key,
    required this.sigunguCodes,
    required this.days,
  });

  _RecommendSelectThemeScreenState createState() => _RecommendSelectThemeScreenState();
}

class _RecommendSelectThemeScreenState extends State<RecommendSelectThemeScreen> {
  final List<String> selectedThemes = [];

  @override
  Widget build(BuildContext context) {
    const themes = TripTheme.values;

    return Scaffold(
      body: Material(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              AppActionBar(
                onBackPressed: () { GoRouter.of(context).pop(); },
                rightText: '3/3',
              ),
              Expanded(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "어떤 여행을 원하시나요?",
                            style: TextStyles.headlineXSmall,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "원하는 여행 테마를 선택해 주세요.",
                            style: TextStyles.bodyLarge
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SelectableGrid(
                        items: themes.map(
                          (theme) => SelectableGridItemData(id: theme.name, emoji: theme.icon, title: theme.title)
                        ).toList(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14
                        ),
                        onSelectionChanged: (String themeId) {
                          setState(() {
                            if (selectedThemes.contains(themeId)) {
                              selectedThemes.remove(themeId);
                            } else {
                              if (selectedThemes.length >= 2) {
                                ToastUtil.showToast(context, "앗! 최대 2개까지만 선택 가능해요.");
                              } else {
                                selectedThemes.add(themeId);
                              }
                            }
                          });
                        },
                        selectedIds: selectedThemes,
                        maxSelection: themes.length,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: "다음",
                    onPressed: () {
                      GoRouter.of(context).push(
                        Uri(
                          path: "${Routes.recommend.path}/${Routes.recommendResult.path}",
                          queryParameters: {
                            "selectedSigunguCodes": widget.sigunguCodes.map((e) => SigunguCode.toJson(e)).join(","),
                            "selectedDays": widget.days.toString(),
                            "selectedTripThemes": selectedThemes.join(","),
                          }
                        ).toString()
                      );
                    },
                    isEnabled: selectedThemes.isNotEmpty,
                    onIllegalPressed: () {
                      ToastUtil.showToast(context, "여행 테마를 선택해 주세요");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
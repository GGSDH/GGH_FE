import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/range_picker_list_item.dart';

import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../../util/toast_util.dart';
import '../component/app/app_action_bar.dart';
import '../component/app/app_button.dart';

class RecommendSelectPeriodScreen extends StatefulWidget {
  final List<SigunguCode> sigunguCodes;

  const RecommendSelectPeriodScreen({
    super.key,
    required this.sigunguCodes,
  });

  @override
  _RecommendSelectPeriodScreenState createState() =>
      _RecommendSelectPeriodScreenState();
}

class _RecommendSelectPeriodScreenState extends State<RecommendSelectPeriodScreen> {

  final now = DateTime.now();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      startDate = DateTime(now.year, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('startDate: $startDate, endDate: $endDate');

    return Scaffold(
        body: Material(
          color: Colors.white,
            child: SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppActionBar(
                rightText: '2/3',
                onBackPressed: () {
                  GoRouter.of(context).pop();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('여행일정은 어떻게 되시나요?',
                          style: TextStyles.headlineXSmall
                              .copyWith(color: ColorStyles.gray900)),
                      const SizedBox(height: 4),
                      Text('첫 날과 마지막 날을 선택해 주세요',
                          style: TextStyles.bodyLarge
                              .copyWith(color: ColorStyles.gray600)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: ColorStyles.primaryLight,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(formatPeriod(startDate!, endDate!),
                            style: TextStyles.bodyLarge
                                .copyWith(color: ColorStyles.primary)),
                      ),
                    ]),
              ),
              Container(
                color: ColorStyles.gray200,
                width: double.infinity,
                height: 1,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        final targetDate =
                            DateTime(now.year, now.month + index, now.day);

                        return Column(
                          children: [
                            if (index != 0)
                              Container(
                                  color: ColorStyles.gray200,
                                  width: double.infinity,
                                  height: 1),
                            RangePickerListItem(
                              now: targetDate,
                              startDate: startDate,
                              endDate: endDate,
                              onDaySelected: (DateTime day) {
                                setState(() {
                                  if (startDate == null || endDate == null) {
                                    startDate = day;
                                    endDate = day;
                                  } else if (day.isBefore(startDate!)) {
                                    if (endDate!.difference(day).inDays > 5) {
                                      ToastUtil.showToast(context, "앗! 최대 5박 6일까지만 가능해요.");
                                    } else {
                                      startDate = day;
                                    }
                                  } else if (day.isAfter(endDate!)) {
                                    if (day.difference(startDate!).inDays > 5) {
                                      ToastUtil.showToast(context, "앗! 최대 5박 6일까지만 가능해요.");
                                    } else {
                                      endDate = day;
                                    }
                                  } else {
                                    startDate = day;
                                    endDate = day;
                                  }
                                });
                              },
                            ),
                            if (index == 5) const SizedBox(height: 60)
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(14),
              child: AppButton(
                text: '다음',
                onPressed: () {
                  GoRouter.of(context).push(
                    Uri(
                      path: "${Routes.recommend.path}/${Routes.recommendSelectTheme.path}",
                      queryParameters: {
                        'selectedSigunguCodes': widget.sigunguCodes
                            .map((e) => SigunguCode.toJson(e))
                            .join(','),
                        'selectedDays': "${endDate!.difference(startDate!).inDays + 1}",
                      },
                    ).toString()
                  );
                },
                isEnabled: startDate != null && endDate != null,
              ),
            ),
          )
        ],
      ),
    )));
  }

  String formatPeriod(DateTime startDate, DateTime endDate) {
    // 시작일의 월, 일, 요일 추출
    String startMonth = startDate.month.toString();
    String startDay = startDate.day.toString();

    // 종료일의 월, 일, 요일 추출
    String endMonth = endDate.month.toString();
    String endDay = endDate.day.toString();

    // 총 며칠인지 계산
    int totalNights = endDate.difference(startDate).inDays; // 총 박 수 계산
    int totalDays = totalNights + 1; // 총 일 수 계산

    // 포맷된 문자열 반환
    return (totalNights == 0 && totalDays == 1)
        ? "$startMonth.$startDay 당일치기"
        : "$startMonth.$startDay - $endMonth.$endDay $totalNights박 $totalDays일";
  }
}

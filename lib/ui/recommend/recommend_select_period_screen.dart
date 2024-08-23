import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/component/range_picker_list_item.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';
import '../component/app/app_button.dart';

class RecommendSelectPeriodScreen extends StatefulWidget {
  const RecommendSelectPeriodScreen({ super.key});

  _RecommendSelectPeriodScreenState createState() => _RecommendSelectPeriodScreenState();
}

class _RecommendSelectPeriodScreenState extends State<RecommendSelectPeriodScreen> {
  final now = DateTime.now();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      startDate = now;
      endDate = now;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
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
                    menuItems: const [],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          '여행일정은 어떻게 되시나요?',
                          style: TextStyles.headlineXSmall.copyWith(
                            color: ColorStyles.gray900
                          )
                        ),

                        const SizedBox(height: 4),

                        Text(
                          '일정을 선택해 주세요',
                          style: TextStyles.bodyLarge.copyWith(
                            color: ColorStyles.gray600
                          )
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: ColorStyles.primaryLight,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            formatPeriod(startDate!, endDate!),
                            style: TextStyles.bodyLarge.copyWith(
                              color: ColorStyles.primary
                            )
                          ),
                        ),
                      ]
                    ),
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
                          final targetDate = DateTime(now.year, now.month + index, now.day);

                          return Column(
                            children: [
                              if (index != 0) Container(
                                  color: ColorStyles.gray200,
                                  width: double.infinity,
                                  height: 1
                              ),
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
                                      startDate = day;
                                    } else if (day.isAfter(endDate!)) {
                                      endDate = day;
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
                        }
                      ),
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
                    onPressed: () { },
                    isEnabled: startDate != null && endDate != null,
                  ),
                ),
              )
            ],
          ),
        )
      )
    );
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
    return (totalNights == 0 && totalDays == 1) ?  "$startMonth.$startDay 당일치기" : "$startMonth.$startDay - $endMonth.$endDay ${totalNights}박 ${totalDays}일";
  }
}
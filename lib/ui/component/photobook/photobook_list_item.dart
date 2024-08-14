import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';

class PhotobookListItem extends StatelessWidget {
  String category;
  String title;
  String period;
  VoidCallback onTap;

  PhotobookListItem({
    super.key,
    required this.category,
    required this.title,
    required this.period,
    required this.onTap,
  });

  String calculateNightsAndDays(String dateRange) {
    final DateFormat dateFormat = DateFormat('yy. MM. dd');

    final List<String> dates = dateRange.split(' ~ ');
    final DateTime startDate = dateFormat.parse(dates[0].trim());
    final DateTime endDate = dateFormat.parse(dates[1].trim());

    final Duration duration = endDate.difference(startDate);

    final int days = duration.inDays + 1; // 하루를 포함하기 위해 +1
    final int nights = duration.inDays;

    return '$nights박 $days일';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    decoration: BoxDecoration(
                      color: ColorStyles.primaryLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category,
                      style: TextStyles.labelMedium.copyWith(
                        color: ColorStyles.primary,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyles.titleLarge.copyWith(
                      color: ColorStyles.gray900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "$period | ${calculateNightsAndDays(period)}",
                        style: TextStyles.bodyMedium.copyWith(
                          color: ColorStyles.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
      
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  "assets/images/img_dummy_place.png",
                  width: 104,
                  height: 104,
                ),
              ),
            ]
        ),
      ),
    );
  }
}
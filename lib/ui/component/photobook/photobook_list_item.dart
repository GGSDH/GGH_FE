import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';
import '../app/app_file_image.dart';
import '../app/app_image_plaeholder.dart';

class PhotobookListItem extends StatelessWidget {
  final String title;
  final String imageFilePath;
  final String startDate;
  final String endDate;
  final String location;
  final VoidCallback onTap;

  const PhotobookListItem({
    super.key,
    required this.title,
    required this.imageFilePath,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.onTap,
  });

  String formatDateRangeAndDuration(String startDate, String endDate) {
    // DateTime으로 변환
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    // 날짜 형식 지정
    final DateFormat dateFormat = DateFormat('yy. MM. dd');

    // 날짜 차이 계산 (일)
    int totalDays = end.difference(start).inDays + 1; // 마지막 날 포함
    int nights = totalDays - 1;

    // 형식화된 날짜 출력
    String formattedDateRange = '${dateFormat.format(start)} ~ ${dateFormat.format(end)}';
    String duration = '${nights}박 ${totalDays}일';

    // 최종 포맷
    return '$formattedDateRange | $duration';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.titleLarge.copyWith(
                        color: ColorStyles.gray900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatDateRangeAndDuration(startDate, endDate),
                            style: TextStyles.bodyMedium.copyWith(
                              color: ColorStyles.gray500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AppFileImage(
                  width: 78,
                  height: 78,
                  imageFilePath: imageFilePath,
                  placeholder: const AppImagePlaceholder(width: 78, height: 78),
                  errorWidget: const AppImagePlaceholder(width: 78, height: 78),
                ),
              )
            ]
        ),
      ),
    );
  }
}
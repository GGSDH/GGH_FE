import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyeonggi_express/ui/component/app/app_file_image.dart';
import 'package:gyeonggi_express/ui/component/app/app_image_plaeholder.dart';
import 'package:intl/intl.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';

class PhotoTicketItem extends StatelessWidget {

  const PhotoTicketItem({
    super.key,
    required this.title,
    required this.filePath,
    required this.startDate,
    required this.endDate,
    required this.location,
  });

  final String title;
  final String filePath;
  final DateTime? startDate;
  final DateTime? endDate;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10), // Add padding to avoid clipping
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: ColorStyles.gray300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: ColorStyles.gray300.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(6, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: ColorStyles.gray900,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            formatNightsAndDays(startDate, endDate),
                            style: TextStyles.titleMedium.copyWith(
                              color: ColorStyles.gray500,
                            )
                          )
                        ]
                    ),
                    const SizedBox(height: 15),

                    Expanded(
                      child: AppFileImage(
                        imageFilePath: filePath,
                        width: double.infinity,
                        height: 120,
                        placeholder: const AppImagePlaceholder(width: double.infinity, height: 120),
                        errorWidget: const AppImagePlaceholder(width: double.infinity, height: 120)
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      formatPeriod(startDate, endDate),
                      style: TextStyles.titleSmall.copyWith(
                        color: ColorStyles.gray900,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_map_pin.svg",
                          width: 14,
                          height: 14,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.gray600,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyles.bodyMedium.copyWith(
                            color: ColorStyles.gray800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 7,
            child: Center(
              child: CustomPaint(
                  size: const Size(25, 40),
                  painter: OffsetRectanglePainter(
                      color: ColorStyles.primary
                  )
              ),
            ),
          )
        ]
      ),
    );
  }

  String formatNightsAndDays(DateTime? startDate, DateTime? endDate) {
    try {
      // 총 며칠인지 계산
      int totalNights = endDate!
          .difference(startDate!)
          .inDays; // 총 박 수 계산
      int totalDays = totalNights + 1; // 총 일 수 계산

      // 포맷된 문자열 반환
      return (totalNights == 0 && totalDays == 1)
          ? "당일치기"
          : "$totalNights박 $totalDays일";
    } catch (e) {
      return "";
    }
  }

  String formatPeriod(DateTime? startDate, DateTime? endDate) {
    try {
      final DateFormat formatter = DateFormat('yy.MM.dd');

      final String formattedStartDate = formatter.format(startDate!);
      final String formattedEndDate = formatter.format(endDate!);

      return '$formattedStartDate ~ $formattedEndDate';
    } catch (e) {
      return "";
    }
    final DateFormat formatter = DateFormat('yy.MM.dd');

    final String formattedStartDate = formatter.format(startDate!);
    final String formattedEndDate = formatter.format(endDate!);

    return '$formattedStartDate ~ $formattedEndDate';
  }
}

class OffsetRectanglePainter extends CustomPainter {
  OffsetRectanglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorStyles.primary
      ..style = PaintingStyle.fill;

    const radius = Radius.circular(4);  // Set radius to 4

    final path = Path()
      ..moveTo(0 + radius.x, 0) // Top left corner
      ..lineTo(size.width - radius.x, 0) // Top right corner
      ..arcToPoint(
        Offset(size.width, radius.y),
        radius: radius,
        clockwise: true,
      )
      ..lineTo(size.width + 7, size.height - radius.y) // Bottom right side
      ..arcToPoint(
        Offset(size.width + 7 - radius.x, size.height),
        radius: radius,
        clockwise: true,
      )
      ..lineTo(7 + radius.x, size.height) // Bottom left side
      ..arcToPoint(
        Offset(7, size.height - radius.y),
        radius: radius,
        clockwise: true,
      )
      ..lineTo(0, radius.y) // Left side
      ..arcToPoint(
        Offset(0 + radius.x, 0),
        radius: radius,
        clockwise: true,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
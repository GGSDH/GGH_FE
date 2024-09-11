import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gyeonggi_express/ui/component/app/app_button.dart';
import 'package:intl/intl.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';

class RangePicker extends StatefulWidget {
  const RangePicker({
    super.key,
    required this.onConfirmed
  });

  final void Function(DateTime startDate, DateTime endDate) onConfirmed;

  @override
  _RangePickerState createState() => _RangePickerState();
}

class _RangePickerState extends State<RangePicker> {
  late DateTime now;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
  }

  void _updateCurrentDate(DateTime date) {
    setState(() {
      now = date;
    });
  }

  void _onConfirm() {
    if (startDate != null && endDate != null) {
      widget.onConfirmed(startDate!, endDate!);
    }
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      if (startDate == null || (endDate != null && day.isBefore(startDate!))) {
        startDate = day;
        endDate = null;
      } else if (endDate == null || day.isAfter(endDate!)) {
        endDate = day;
      } else {
        startDate = day;
        endDate = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final weeks = getNumberOfWeeksInMonth(now);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: Column(
          children: [
            TitleHeader(onClose: () => Navigator.pop(context)),
            YearMonthHeader(
              currentDate: now,
              onDateSelected: _updateCurrentDate,
            ),
            const SizedBox(height: 20),
            const WeekHeader(),
            ...weeks.map((week) => Week(
              weekDays: week,
              onDaySelected: _onDaySelected,
              startDate: startDate,
              endDate: endDate,
            )),
            const SizedBox(height: 30),
            AppButton(
              text: '다음',
              onPressed: _onConfirm,
              isEnabled: startDate != null && endDate != null,
            )
          ],
        ),
      ),
    );
  }

  List<List<DateTime?>> getNumberOfWeeksInMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    List<DateTime?> days = [];
    int daysInMonth = lastDayOfMonth.day;

    for (int i = 0; i < firstDayOfMonth.weekday - 1; i++) {
      days.add(null);
    }

    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(date.year, date.month, i));
    }

    while (days.length % 7 != 0) {
      days.add(null);
    }

    List<List<DateTime?>> weeks = [];
    for (int i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7));
    }

    return weeks;
  }
}

class TitleHeader extends StatelessWidget {
  final void Function() onClose;

  const TitleHeader({
    super.key,
    required this.onClose
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '기간 선택',
            style: TextStyles.headlineXSmall.copyWith(
              color: ColorStyles.gray900
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: SvgPicture.asset(
              'assets/icons/ic_close_24px.svg',
              width: 24,
              height: 24
            )
          )
        ]
      ),
    );
  }
}

class YearMonthHeader extends StatelessWidget {
  final DateTime currentDate;
  final void Function(DateTime) onDateSelected;

  const YearMonthHeader({
    super.key,
    required this.currentDate,
    required this.onDateSelected
  });

  void _onLeftArrowTap() {
    final newDate = DateTime(currentDate.year, currentDate.month - 1);
    onDateSelected(newDate);
  }

  void _onRightArrowTap() {
    final newDate = DateTime(currentDate.year, currentDate.month + 1);
    onDateSelected(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _onLeftArrowTap,
          child: SvgPicture.asset(
            'assets/icons/ic_arrow_left_20px.svg',
            width: 20,
            height: 20
          )
        ),
        const SizedBox(width: 14),
        Text(
          DateFormat('y년 M월').format(currentDate),
          style: TextStyles.headlineXSmall.copyWith(
              color: ColorStyles.gray900
          ),
        ),
        const SizedBox(width: 14),
        GestureDetector(
          onTap: _onRightArrowTap,
          child: SvgPicture.asset(
            'assets/icons/ic_arrow_right_20px.svg',
            width: 20,
            height: 20
          )
        ),
      ]
    );
  }
}

class WeekHeader extends StatelessWidget {
  const WeekHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final weekdays = ['일', '월', '화', '수', '목', '금',' 토'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: weekdays.map((day) {
        final textColor = day == '일'
            ? ColorStyles.error
            : day == "토"
            ? ColorStyles.primary
            : ColorStyles.gray700;

        return Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height: 42,
            child: Text(
              day,
              style: TextStyles.titleSmall.copyWith(
                color: textColor
              )
            )
          ),
        );
      }).toList()
    );
  }
}

class Week extends StatelessWidget {
  final List<DateTime?> weekDays;
  final Function(DateTime) onDaySelected;
  final DateTime? startDate;
  final DateTime? endDate;

  const Week({
    super.key,
    required this.weekDays,
    required this.onDaySelected,
    required this.startDate,
    required this.endDate
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((day) {
        if (day == null) {
          return const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: SizedBox(height: 42)
            ),
          );
        } else {
          return Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Day(
                day: day,
                onDaySelected: onDaySelected,
                startDate: startDate,
                endDate: endDate,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}

class Day extends StatelessWidget {
  final DateTime day;
  final Function(DateTime) onDaySelected;
  final DateTime? startDate;
  final DateTime? endDate;

  const Day({
    super.key,
    required this.day,
    required this.onDaySelected,
    required this.startDate,
    required this.endDate
  });

  @override
  Widget build(BuildContext context) {
    final isAfterToday = day.isAfter(DateTime.now());

    bool isSelected = startDate != null &&
        endDate != null &&
        day.isAfter(startDate!.subtract(const Duration(hours: 6))) &&
        day.isBefore(endDate!.add(const Duration(hours: 6)));

    bool isToday = day.year == DateTime.now().year &&
        day.month == DateTime.now().month &&
        day.day == DateTime.now().day;
    bool isStartDay = startDate != null &&
        startDate!.year == day.year &&
        startDate!.month == day.month &&
        startDate!.day == day.day;
    bool isEndDay = endDate != null &&
        endDate!.year == day.year &&
        endDate!.month == day.month &&
        endDate!.day == day.day;

    final borderRadius = BorderRadius.only(
      topLeft: isStartDay ? const Radius.circular(30) : Radius.zero,
      bottomLeft: isStartDay ? const Radius.circular(30) : Radius.zero,
      topRight: isEndDay ? const Radius.circular(30) : Radius.zero,
      bottomRight: isEndDay ? const Radius.circular(30) : Radius.zero,
    );

    final textColor = isAfterToday
        ? ColorStyles.gray300
        : isStartDay || isEndDay
        ? ColorStyles.gray50
        : isToday
        ? ColorStyles.primary
        : ColorStyles.gray700;

    return GestureDetector(
      onTap: !isAfterToday ? () => onDaySelected(day) : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: (isSelected && !isStartDay && !isEndDay) ? BorderRadius.zero : borderRadius,
          color: isSelected ? ColorStyles.primaryLight : Colors.transparent,
        ),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(vertical: 3.5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: isStartDay || isEndDay ? BorderRadius.circular(30) : BorderRadius.zero,
            color: isStartDay || isEndDay ? ColorStyles.primary : Colors.transparent,
          ),
          child: Text(
            day.day.toString(),
            style: TextStyles.titleSmall.copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
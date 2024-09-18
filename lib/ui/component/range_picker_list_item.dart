import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';

class RangePickerListItem extends StatelessWidget {
  const RangePickerListItem({
    super.key,
    required this.now,
    required this.startDate,
    required this.endDate,
    required this.onDaySelected,
  });

  final DateTime now;
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime) onDaySelected;

  @override
  Widget build(BuildContext context) {
    final weeks = getNumberOfWeeksInMonth(now);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YearMonthHeader(currentDate: now),
            const WeekHeader(),
            ...weeks.map((week) => Week(
              now: now,
              weekDays: week,
              onDaySelected: onDaySelected,
              startDate: startDate,
              endDate: endDate,
            )),
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

    int startingEmptyDays = (firstDayOfMonth.weekday % 7); // Sunday should be 0

    for (int i = 0; i < startingEmptyDays; i++) {
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

class YearMonthHeader extends StatelessWidget {
  const YearMonthHeader({
    super.key,
    required this.currentDate
  });

  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text(DateFormat('yyyy.MM').format(currentDate),
        style: TextStyles.titleMedium.copyWith(
          color: ColorStyles.gray900
        )
      )
    );
  }
}

class WeekHeader extends StatelessWidget {
  const WeekHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];

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
              padding: const EdgeInsets.symmetric(vertical: 7),
              height: 32,
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
  final DateTime now;
  final List<DateTime?> weekDays;
  final Function(DateTime) onDaySelected;
  final DateTime? startDate;
  final DateTime? endDate;

  const Week({
    super.key,
    required this.now,
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
            child: SizedBox(height: 54)
          );
        } else {
          return Day(
            now: DateTime.now(),
            day: day,
            onDaySelected: onDaySelected,
            startDate: startDate,
            endDate: endDate,
          );
        }
      }).toList(),
    );
  }
}

class Day extends StatelessWidget {
  final DateTime now;
  final DateTime day;
  final Function(DateTime) onDaySelected;
  final DateTime? startDate;
  final DateTime? endDate;

  const Day({
    super.key,
    required this.now,
    required this.day,
    required this.onDaySelected,
    required this.startDate,
    required this.endDate
  });

  @override
  Widget build(BuildContext context) {
    final isBeforeToday = day.isBefore(DateTime(now.year, now.month, now.day));

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

    final textColor = isBeforeToday
        ? ColorStyles.gray300
        : isStartDay || isEndDay
        ? ColorStyles.gray50
        : isToday
        ? ColorStyles.primary
        : ColorStyles.gray700;

    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: !isBeforeToday ? () => onDaySelected(day) : null,
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(vertical: 7),
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints.expand(),
            alignment: Alignment.center,
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
                style: TextStyle(
                  color: textColor
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
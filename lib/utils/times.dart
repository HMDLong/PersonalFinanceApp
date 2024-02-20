import 'dart:math';

import 'package:intl/intl.dart';

class TimeRange {
  late DateTime start;
  late DateTime end;

  int get duration => end.difference(start).inDays;

  TimeRange({
    required DateTime start,
    required DateTime end,
  }) {
    this.start = start.toDateOnly();
    this.end = end.toDateOnly();
  }

  @override
  String toString() {
    final formatter = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
    return "${formatter.format(start)} ~ ${formatter.format(end)}";
  }

  /// Check if a [date] is between this range
  bool contain(DateTime date) {
    final dateOnly = date.toDateOnly();
    if(dateOnly.isBefore(start)) return false;
    if(dateOnly.isAfter(end)) return false;
    return true;
  }

  /// Return a list contains all the dates that in this range
  List<DateTime> getRangeDates(){
    final rangeDuration = duration;
    return List<DateTime>.generate(rangeDuration + 1, (index) => start.add(Duration(days: index)));
  }

  List<DateTime> weekdaysOfRange(int weekday) {
    final res = <DateTime>[];
    final dist = weekday - start.weekday;
    var occurence = start.add(Duration(days: dist >= 0 ? dist : dist + 7));
    while(occurence.isBefore(end)) {
      res.add(occurence);
      occurence = occurence.add(const Duration(days: 7));
    }
    return res;
  }

  List<DateTime> monthdaysOfRange(int monthday) {
    final res = <DateTime>[];
    final daysInMonth = getDaysInMonth(start.year, start.month);
    res.add(DateTime(start.year, start.month, min(monthday, daysInMonth)));
    return res;
  }
}

extension TimeRangeExt on DateTime {
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }

  DateTime to9PM(){
    return DateTime(year, month, day, 21, 0, 0);
  }

  DateTime to9AM(){
    return DateTime(year, month, day, 9, 0, 0);
  }
}

// ------------------ Custom range ----------------------
TimeRange getNDaysBefore(DateTime date, int n) {
  final dateOnly = date.toDateOnly();
  return TimeRange(
    start: dateOnly.subtract(Duration(days: n)), 
    end: dateOnly,
  );
}

List<DateTime> getDayOfEveryWeekInMonth(DateTime anchor, int dayInWeek) {
  final monthRange = getRangeOfTheMonth(date: anchor);
  final res = <DateTime>[];
  var lastDayInWeek = monthRange.end;
  while(lastDayInWeek.weekday != dayInWeek) {
    lastDayInWeek = lastDayInWeek.subtract(const Duration(days: 1));
  }
  do {
    res.add(lastDayInWeek);
    lastDayInWeek = lastDayInWeek.subtract(const Duration(days: 7));
  } while (monthRange.contain(lastDayInWeek));
  return res;
}

//------------------- Day as range -----------------------
TimeRange getRangeOfDay({DateTime? date}){
  final theDay = date ?? DateTime.now();
  return TimeRange(
    start: theDay.toDateOnly(), 
    end: theDay.toDateOnly(),
  );
}

TimeRange getNextDayRange({required TimeRange range}){
  return TimeRange(
    start: range.start.add(const Duration(days: 1)), 
    end: range.start.add(const Duration(days: 1)),
  );
}

TimeRange getPreviousDayRange({required TimeRange range}){
  return TimeRange(
    start: range.start.subtract(const Duration(days: 1)), 
    end: range.start.subtract(const Duration(days: 1)),
  );
}

//------------------- Week as range ----------------------
TimeRange getRangeOfTheWeek({DateTime? targetDate}) {
  final anchor = targetDate ?? DateTime.now();
  final monday = DateTime.now().subtract(Duration(days: anchor.weekday - DateTime.monday));
  final sunday = monday.add(const Duration(days: 6));
  return TimeRange(start: monday, end: sunday);
}

TimeRange getPreviousWeekRangeByDate({required DateTime date}) {
  final targetRange = getRangeOfTheWeek(targetDate: date);
  return getPreviousWeekRangeByRange(range: targetRange);
}

TimeRange getPreviousWeekRangeByRange({required TimeRange range}) {
  return TimeRange(
    start: range.start.subtract(const Duration(days: 7)),
    end: range.end.subtract(const Duration(days: 7)),
  );
}

TimeRange getNextWeekRangeByDate({required DateTime date}) {
  final targetRange = getRangeOfTheWeek(targetDate: date);
  return getNextWeekRangeByRange(range: targetRange);
}

TimeRange getNextWeekRangeByRange({required TimeRange range}) {
  return TimeRange(
    start: range.start.add(const Duration(days: 7)),
    end: range.end.add(const Duration(days: 7)),
  );
}

//----------------------- Month as range ------------------------------
int getDaysInMonth(int year, int month) {
  if (month == DateTime.february) {
    final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
    return isLeapYear ? 29 : 28;
  }
  const List<int> daysInMonth = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  return daysInMonth[month - 1];
}

TimeRange getRangeOfTheMonth({DateTime? date}) {
  final date_ = date ?? DateTime.now();
  return TimeRange(
    start: DateTime(date_.year, date_.month, 1), 
    end: DateTime(date_.year, date_.month, getDaysInMonth(date_.year, date_.month)),
  );
}

TimeRange getPreviousMonthRangeByDate({required DateTime date}) {
  final targetRange = getRangeOfTheMonth(date: date);
  return getPreviousWeekRangeByRange(range: targetRange);
}

TimeRange getPreviousMonthRangeByRange({required TimeRange range}) {
  final start = range.start;
  if(start.month == 1) {
    return TimeRange(
      start: DateTime(start.year - 1, 12, 1),
      end: DateTime(start.year - 1, 12, 31),
    );
  }
  return TimeRange(
    start: DateTime(start.year, start.month - 1, 1),
    end: DateTime(start.year, start.month - 1, getDaysInMonth(start.year, start.month - 1)),
  );
}

TimeRange getNextMonthRangeByDate({required DateTime date}) {
  final targetRange = getRangeOfTheMonth(date: date);
  return getNextMonthRangeByRange(range: targetRange);
}

TimeRange getNextMonthRangeByRange({required TimeRange range}) {
  final start = range.start;
  if(start.month == 12) {
    return TimeRange(
      start: DateTime(start.year + 1, 1, 1),
      end: DateTime(start.year + 1, 1, 31),
    );
  }
  return TimeRange(
    start: DateTime(start.year, start.month + 1, 1),
    end: DateTime(start.year, start.month + 1, getDaysInMonth(start.year, start.month + 1)),
  );
}

//--------------- Year as range -----------------
TimeRange getRangeOfTheYear({DateTime? date}) {
  final date_ = date ?? DateTime.now();
  return TimeRange(
    start: DateTime(date_.year, 1, 1), 
    end: DateTime(date_.year, 12, 31),
  );
}

TimeRange getNextYearRange({required TimeRange range}) {
  final start = range.start;
  return TimeRange(
    start: DateTime(start.year + 1, 1, 1), 
    end: DateTime(start.year + 1, 12, 31),
  );
}

TimeRange getPreviousYearRange({required TimeRange range}) {
  final start = range.start;
  return TimeRange(
    start: DateTime(start.year - 1, 1, 1), 
    end: DateTime(start.year - 1, 12, 31),
  );
}

void main() {
  print(getDayOfEveryWeekInMonth(DateTime.now(), 2));
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// some helpful DateTime extensions
extension TimeDateUtils on DateTime {
  static DateTime zero = DateTime(1970, 1, 1, 0, 0, 0);

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  /// is this date a day before the given day
  bool isYesterday(DateTime today) {
    var yesterday = DateTime(today.year, today.month, today.day - 1);
    return isSameDay(yesterday);
  }

  /// is this date one day after the given day
  bool isTomorrow(DateTime today) {
    var tomorrow = DateTime(today.year, today.month, today.day + 1);
    return tomorrow.year == year && tomorrow.month == month && tomorrow.day == day;
  }

  /// is this month after the given one
  bool isMonthAfter(DateTime other) {
    int thisYear = year;
    int otherYear = other.year;

    return (thisYear > otherYear) || (thisYear == otherYear && month > other.month);
  }

  /// is the given month before this one
  bool isMonthBefore(DateTime other) {
    int thisYear = year;
    int otherYear = other.year;

    return (thisYear < otherYear) || (thisYear == otherYear && month < other.month);
  }

  /// is this day after a given other
  bool isDayAfter(DateTime other) {
    int thisYear = year;
    int otherYear = other.year;

    if (thisYear > otherYear) return true;

    int thisMonth = month;
    int otherMonth = other.month;

    return (thisYear >= otherYear && thisMonth > otherMonth) ||
        (thisYear >= otherYear && thisMonth >= otherMonth && day > other.day);
  }

  /// is this day before a given other
  bool isDayBefore(DateTime other) {
    int thisYear = year;
    int otherYear = other.year;

    if (thisYear < otherYear) return true;

    int thisMonth = month;
    int otherMonth = other.month;

    return (thisYear <= otherYear && thisMonth < otherMonth) ||
        (thisYear <= otherYear && thisMonth >= otherMonth && day < other.day);
  }

  /// is this day after or on the same day as a given other
  bool isSameDayOrAfter(DateTime other) {
    return isDayAfter(other) || isSameDay(other);
  }

  /// is this day before or on the same day as a given other
  bool isSameDayOrBefore(DateTime other) {
    return isDayBefore(other) || isSameDay(other);
  }

  /// find the first day of the week this day is part of
  DateTime firstDateOfTheWeek() {
    var date = subtract(Duration(days: weekday - 1));
    return DateTime(date.year, date.month, date.day);
  }

  /// find the last date of the week this day is part of
  DateTime lastDateOfTheWeek() {
    var date = add(Duration(days: DateTime.daysPerWeek - weekday));
    return DateTime(date.year, date.month, date.day);
  }

  /// return same time that occurs on the given day
  DateTime getOnDay(DateTime today) {
    return DateTime(today.year, today.month, today.day, hour, minute, second, millisecond);
  }

  /// return same date that occurs with the given time of day
  DateTime withTimeOfDay(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  /// return DateTime as a TimeOfDay
  TimeOfDay getTimeOfDay() {
    return TimeOfDay.fromDateTime(this);
  }

  /// get number representation as four digits
  static String fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? '-' : '';

    if (absN >= 1000) return '$n';
    if (absN >= 100) return '${sign}0$absN';
    if (absN >= 10) return '${sign}00$absN';

    return '${sign}000$absN';
  }

  /// get number representation as six digits
  static String sixDigits(int n) {
    assert(n < -9999 || n > 9999);
    int absN = n.abs();
    String sign = n < 0 ? '-' : '+';
    if (absN >= 100000) return '$sign$absN';
    return '${sign}0$absN';
  }

  /// get number representation as two digits
  static String twoDigits(int n) {
    return n >= 10 ? '$n' : '0$n';
  }

  /// Creates a more compact iso 8601 string without milliseconds and microseconds.
  String toCompactIso8601String() {
    String y = (year >= -9999 && year <= 9999) ? fourDigits(year) : sixDigits(year);
    String m = twoDigits(month);
    String d = twoDigits(day);
    String h = twoDigits(hour);
    String min = twoDigits(minute);
    String sec = twoDigits(second);

    if (isUtc) {
      return '$y-$m-${d}T$h:$min:${sec}Z';
    } else {
      return '$y-$m-${d}T$h:$min:$sec';
    }
  }

  /// get total days in a given month
  static int daysInMonth(int month, {int year = 2022}) {
    // correct month/year if month outside of range
    do {
      if (month > 12) {
        month = month - 12;
        year = year + 1;
        debugPrintStack();
      } else if (month < 1) {
        month = month + 12;
        year = year - 1;
        debugPrintStack();
      }
    } while (month < 1 || month > 12);

    return DateTime(year, month + 1, 0).day;
  }

  /// get total seconds in a given month
  static int secondsInMonth(int month, {int year = 2022}) {
    var days = daysInMonth(month, year: 2022);

    return days * 24 * 3600;
  }

  /// get total days in this month
  static DateTime lastDateInMonth(int month, {int year = 2022}) {
    return DateTime(year, month, daysInMonth(month, year: year));
  }

  /// check if a year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }

  /// get total days in this month
  static int daysInYear(int year) {
    return !isLeapYear(year) ? 365 : 366;
  }

  static int daysInYearSoFar(DateTime day) {
    return day.difference(DateTime(day.year, 1, 1)).inDays;
  }

  /// Calculates number of weeks for a given year as per
  /// https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per
  /// https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int weekNumber() {
    int dayOfYear = int.parse(DateFormat("D").format(this));
    int woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(year - 1);
    } else if (woy > numOfWeeks(year)) {
      woy = 1;
    }
    return woy;
  }

  /// return elapsed time in seconds
  double elapsed() {
    var end = DateTime.now();
    var diff = end.difference(this);
    return diff.elapsed();
  }

  int elapsedInMilliseconds() {
    var end = DateTime.now();
    var diff = end.difference(this);
    return diff.inMilliseconds;
  }

  DateTime clone({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    bool? isUtc,
  }) {
    if (isUtc ?? this.isUtc) {
      return DateTime.utc(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
      );
    }
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
    );
  }

  /// is the value of the variable zero time (0/1/1 0:0:0)
  bool isZeroTime() {
    return year == 0 && month == 1 && day == 1 && hour == 0 && minute == 0 && second == 0;
  }

  /// is the value of the variable zero time (0/1/1 0:0:0)
  bool isEpochTime() {
    return year == 1970 && month == 1 && day == 1 && hour == 0 && minute == 0 && second == 0;
  }

  /// does a DateTime match a year/month/day
  bool equalsYMD(int year, int month, int day) {
    return this.year == year && this.month == month && this.day == day;
  }
}

/// some helpful nullable DateTime extensions
extension TimeDateNullableUtils on DateTime? {
  bool equalsNullable(DateTime? other) {
    if (this == null && other == null) {
      return true;
    } else if (this != null && other != null) {
      return this! == other;
    }

    return false;
  }

  int compareNullable(DateTime? other) {
    if (this == null && other == null) {
      return 0;
    } else if (this != null && other == null) {
      return 1;
    } else if (this == null && other != null) {
      return -1;
    } else {
      return this!.compareTo(other!);
    }
  }

  static DateTime? newer(DateTime? a, DateTime? b) {
    var compared = a.compareNullable(b);

    if (compared == 1) {
      return a;
    } else if (compared == -1) {
      return b;
    }

    return a;
  }

  /// does a nullable DateTime match a year/month/day
  bool equalsNullableYMD(int year, int month, int day) {
    if (this != null) {
      return this!.year == year && this!.month == month && this!.day == day;
    }

    return false;
  }
}

/// extensions for TimeOfDay
extension TimeOfDayUtils on TimeOfDay {
  /// get ToD formatted as a time string
  String getTimeString() {
    return '$hour:${minute.toString().padLeft(2, '0')}';
  }

  /// Return DateTime for this TimeOfDay.
  /// Sets year, month and day from now, and only hour and minute from this TimeOfDay.
  DateTime getTime(DateTime now) {
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  /// checks if this ToD is before the other
  bool isBefore(TimeOfDay other) {
    return toDouble() < other.toDouble();
  }

  /// checks if this ToD is before the other
  bool isAfter(TimeOfDay other) {
    return toDouble() > other.toDouble();
  }

  /// convert a ToD value to double
  double toDouble() {
    return hour + minute / 60.0;
  }

  /// create a new instance with the same values
  TimeOfDay copy() {
    return TimeOfDay(hour: hour, minute: minute);
  }
}

/// extensions for Duration class
extension DurationUtils on Duration {
  /// format duration into Hm representation
  String formatHm() {
    var d = DateTime(1970, 1, 1, 0, 0, inSeconds);
    return DateFormat.Hm().format(d);
  }

  /// returns elapsed time in seconds
  double elapsed() {
    return inMicroseconds / 1000 / 1000;
  }
}

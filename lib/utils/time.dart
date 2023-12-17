import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// some helpful DateTime extensions
extension TimeDateUtils on DateTime {
  static DateTime zero = DateTime(1970, 1, 1, 0, 0, 0);

  bool isSameDay(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return this.year == other.year && this.month == other.month;
  }

  bool isSameYear(DateTime other) {
    return this.year == other.year;
  }

  /// is this date a day before the given day
  bool isYesterday(DateTime today) {
    var yesterday = DateTime(today.year, today.month, today.day - 1);
    return this.isSameDay(yesterday);
  }

  /// is this date one day after the given day
  bool isTomorrow(DateTime today) {
    var tomorrow = DateTime(today.year, today.month, today.day + 1);
    return tomorrow.year == this.year && tomorrow.month == this.month && tomorrow.day == this.day;
  }

  /// is this month after the given one
  bool isMonthAfter(DateTime other) {
    return (this.year > other.year) || (this.year == other.year && this.month > other.month);
  }

  /// is the given month before this one
  bool isMonthBefore(DateTime other) {
    return (this.year < other.year) || (this.year == other.year && this.month < other.month);
  }

  /// is this day after a given other
  bool isDayAfter(DateTime other) {
    return this.year > other.year ||
        (this.year >= other.year && this.month > other.month) ||
        (this.year >= other.year && this.month >= other.month && this.day > other.day);
  }

  /// is this day before a given other
  bool isDayBefore(DateTime other) {
    return this.year < other.year ||
        (this.year <= other.year && this.month < other.month) ||
        (this.year <= other.year && this.month >= other.month && this.day < other.day);
  }

  /// is this day after or on the same day as a given other
  bool isSameDayOrAfter(DateTime other) {
    return this.isDayAfter(other) || this.isSameDay(other);
  }

  /// is this day before or on the same day as a given other
  bool isSameDayOrBefore(DateTime other) {
    return this.isDayBefore(other) || this.isSameDay(other);
  }


  /// find the first day of the week this day is part of
  DateTime firstDateOfTheWeek() {
    var date = this.subtract(Duration(days: this.weekday - 1));
    return DateTime(date.year, date.month, date.day);
  }

  /// find the last date of the week this day is part of
  DateTime lastDateOfTheWeek() {
    var date = this.add(Duration(days: DateTime.daysPerWeek - this.weekday));
    return DateTime(date.year, date.month, date.day);
  }

  /// return same time that occurs on the given day
  DateTime getOnDay(DateTime today) {
    return DateTime(
        today.year,
        today.month,
        today.day,
        this.hour,
        this.minute,
        this.second,
        this.millisecond
    );
  }

  /// return same date that occurs with the given time of day
  DateTime withTimeOfDay(TimeOfDay time) {
    return DateTime(this.year, this.month, this.day, time.hour, time.minute);
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

  /// Creates a more compact iso 8601 string without mili and microseconds.
  String toCompactIso8601String() {
    String y = (year >= -9999 && year <= 9999) ? fourDigits(year) : sixDigits(year);
    String m = twoDigits(month);
    String d = twoDigits(day);
    String h = twoDigits(hour);
    String min = twoDigits(minute);
    String sec = twoDigits(second);

    if (isUtc)
      return '$y-$m-${d}T$h:$min:${sec}Z';
    else
      return '$y-$m-${d}T$h:$min:$sec';
  }

  /// get total days in a given month
  static int daysInMonth(int month, {int year = 2022}) {
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
    return day
        .difference(DateTime(day.year, 1, 1))
        .inDays;
  }

  /// Calculates number of weeks for a given year as per
  /// https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per
  /// https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
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

  int elapsedInMiliseconds() {
    var end = DateTime.now();
    var diff = end.difference(this);
    return diff.inMilliseconds;
  }

  DateTime clone({
    int? year = null,
    int? month = null,
    int? day = null,
    int? hour = null,
    int? minute = null,
    int? second = null,
    int? millisecond = null,
    bool? isUtc = null,
  }) {
    if (isUtc == null ? this.isUtc : isUtc) {
      return DateTime.utc(
        year == null ? this.year : year,
        month == null ? this.month : month,
        day == null ? this.day : day,
        hour == null ? this.hour : hour,
        minute == null ? this.minute : minute,
        second == null ? this.second : second,
        millisecond == null ? this.millisecond : millisecond,
      );
    }
    return DateTime(
      year == null ? this.year : year,
      month == null ? this.month : month,
      day == null ? this.day : day,
      hour == null ? this.hour : hour,
      minute == null ? this.minute : minute,
      second == null ? this.second : second,
      millisecond == null ? this.millisecond : millisecond,
    );
  }

  /// is the value of the variable zero time (0/1/1 0:0:0)
  bool isZeroTime() {
    return this.year == 0 && this.month == 1 && this.day == 1 && this.hour == 0 && this.minute == 0 &&
        this.second == 0;
  }

  /// is the value of the variable zero time (0/1/1 0:0:0)
  bool isEpochTime() {
    return this.year == 1970 && this.month == 1 && this.day == 1 && this.hour == 0 && this.minute == 0 &&
        this.second == 0;
  }
}

/// some helpful nullable DateTime extensions
extension TimeDateNullableUtils on DateTime? {
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
}

/// extensions for TimeOfDay
extension TimeOfDayUtils on TimeOfDay {
  /// get ToD formatted as a time string
  String getTimeString() {
    return this.hour.toString() + ':' + this.minute.toString().padLeft(2, '0');
  }

  /// Return DateTime for this TimeOfDay.
  /// Sets year, month and day from now, and only hour and minute from this TimeOfDay.
  DateTime getTime(DateTime now) {
    return DateTime(now.year, now.month, now.day, this.hour, this.minute);
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
    var d = DateTime(1970, 1, 1, 0, 0, this.inSeconds);
    return DateFormat.Hm().format(d);
  }

  /// returns elapsed time in seconds
  double elapsed() {
    return inMicroseconds / 1000 / 1000;
  }
}

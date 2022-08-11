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

  bool isYesterday(DateTime today) {
    return this.year == today.year && this.month == today.month && this.day == today.day - 1;
  }

  /// is the given month after this one
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

  /// is this day after a given other
  bool isSameDayOrAfter(DateTime other) {
    return this.isDayAfter(other) || this.isSameDay(other);
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
      this.millisecond,
    );
  }

  /// return same date that occurs with the given time of day
  DateTime withTimeOfDay(TimeOfDay time) {
    return DateTime(
      this.year,
      this.month,
      this.day,
      time.hour,
      time.minute,
    );
  }


  /// return DateTime as a TimeOfDay
  TimeOfDay getTimeOfDay() {
    return TimeOfDay.fromDateTime(this);
  }

  /// get number representation as four digits
  static String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? '-' : '';

    if (absN >= 1000) return '$n';
    if (absN >= 100) return '${sign}0$absN';
    if (absN >= 10) return '${sign}00$absN';

    return '${sign}000$absN';
  }

  /// get number representation as six digits
  static String _sixDigits(int n) {
    assert(n < -9999 || n > 9999);
    int absN = n.abs();
    String sign = n < 0 ? '-' : '+';
    if (absN >= 100000) return '$sign$absN';
    return '${sign}0$absN';
  }

  /// get number representation as two digits
  static String _twoDigits(int n) {
    if (n >= 10) return '${n}';
    return '0${n}';
  }

  /// Creates a more compact iso 8601 string without mili and microseconds.
  String toCompactIso8601String() {
    String y = (year >= -9999 && year <= 9999) ? _fourDigits(year) : _sixDigits(year);
    String m = _twoDigits(month);
    String d = _twoDigits(day);
    String h = _twoDigits(hour);
    String min = _twoDigits(minute);
    String sec = _twoDigits(second);

    if (isUtc)
      return '$y-$m-${d}T$h:$min:${sec}Z';
    else
      return '$y-$m-${d}T$h:$min:$sec';
  }

  /// get total days in this month
  static int daysInMonth(int month, {int year = 2022}) {
    return DateTime(year, month + 1, 0).day;
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

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
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

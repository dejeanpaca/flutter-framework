import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/localizations/localization.dart';

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
    return (other.year > this.year) || (other.year == this.year && other.month > this.month);
  }

  /// is the given month before this one
  bool isMonthBefore(DateTime other) {
    return (other.year < this.year) || (other.year == this.year && other.month < this.month);
  }

  /// is this day after a given other
  bool isDayAfter(DateTime other) {
    return other.year > this.year ||
        (other.year >= this.year && other.month > this.month) ||
        (other.year >= this.year && other.month >= this.month && other.day > this.day);
  }

  /// is this day after a given other
  bool isSameDayOrAfter(DateTime other) {
    return this.isDayAfter(other) || this.isSameDay(other);
  }

  /// find the first day of the week this day is part of
  DateTime firstDateOfTheWeek() {
    return this.subtract(Duration(days: this.weekday - 1));
  }

  /// find the last date of the week this day is part of
  DateTime lastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
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
}

/// extensions for TimeOfDay
extension TimeOfDayUtils on TimeOfDay {
  String getTimeString() {
    return this.hour.toString() + ':' + this.minute.toString().padLeft(2, '0');
  }

  /// Return DateTime for this TimeOfDay.
  /// Sets year, month and day from now, and only hour and minute from this TimeOfDay.
  DateTime getTime(DateTime now) {
    return DateTime(now.year, now.month, now.day, this.hour, this.minute);
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

/// get representation to show year and month
String getYearMonthRepresentation(DateTime month, {DateTime? today}) {
  if (today == null)
    return DateFormat.yMMMM().format(month);
  else
    return getRelativeMonthRepresentation(month, today);
}

/// represent time in a relative fashion
String getMonthlyTimeRepresentation(DateTime day, DateTime today, {bool useFormat = true, String format = 'd. EEEE'}) {
  var caption = 'Today';
  var localizedFormat = DateFormat(format).format(day);
  if (useFormat) caption = caption + ' ($localizedFormat)';

  if (!day.isSameDay(today)) {
    if (day.isYesterday(today)) {
      if (!useFormat)
        caption = 'Yesterday';
      else
        caption = 'Yesterday ($localizedFormat)';
    } else {
      if (!useFormat)
        caption = Localization.current.getDayOfMonth(day.day);
      else
        caption = localizedFormat;
    }
  }

  return caption;
}

String getRelativeMonthRepresentation(DateTime month, DateTime current) {
  if (current.isSameYear(month))
    return DateFormat.MMMM().format(month);
  else
    return DateFormat.yMMMM().format(month);
}

String getRelativeDayRepresentation(DateTime day, DateTime today, {bool useFormat = true}) {
  if (day.isSameMonth(today))
    return getTimeRepresentation(day, today, useFormat: useFormat);
  else {
    if (day.isSameYear(today))
      return DateFormat.MMMMd().format(day);
    else
      return DateFormat.yMMMMd().format(day);
  }
}

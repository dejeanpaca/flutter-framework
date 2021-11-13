import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/localizations/localization.dart';

extension TimeDateUtils on DateTime {
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
      this.millisecond,);
  }

  /// return DateTime as a TimeOfDay
  TimeOfDay getTimeOfDay() {
    return TimeOfDay.fromDateTime(this);
  }
}

/// extensions for TimeOfDay
extension TimeOfDayUtils on TimeOfDay {
  String getTimeString() {
    return this.hour.toString() + ':' + this.minute.toString().padLeft(2, '0');
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
String getTimeRepresentation(DateTime day, DateTime today, {bool useFormat = true, String format = 'd. EEEE'}) {
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

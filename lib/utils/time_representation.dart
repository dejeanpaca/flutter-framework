import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/localizations/localization.dart';
import 'time.dart';

/// get representation to show year and month
String getYearMonthRepresentation(DateTime month, {DateTime? today}) {
  if (today == null)
    return DateFormat.yMMMM().format(month);
  else
    return getRelativeMonthRepresentation(month, today);
}

/// represent time in a relative fashion within a single month
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
    return getMonthlyTimeRepresentation(day, today, useFormat: useFormat);
  else {
    if (day.isSameYear(today))
      return DateFormat.MMMMd().format(day);
    else
      return DateFormat.yMMMMd().format(day);
  }
}

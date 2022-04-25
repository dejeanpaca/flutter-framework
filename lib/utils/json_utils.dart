import 'dart:ui';
import 'package:flutter/material.dart';

class JsonUtils {
  /// get string
  static String getString(dynamic value, String defaultValue) {
    if (value == null) return defaultValue;

    if (value is String) return value;

    return defaultValue;
  }

  /// get int from a string/int, or return given default if value is not a valid int (no exception is raised)
  static int getInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;

    if (value is String) {
      var v = int.tryParse(value);
      return v != null ? v : defaultValue;
    } else if (value is int) {
      return value;
    }

    return defaultValue;
  }

  /// get int from a string/int, or return given default if value is not a valid int (no exception is raised)
  static int? getIntNullable(dynamic value, int? defaultValue) {
    if (value == null) return defaultValue;

    if (value is String) {
      var v = int.tryParse(value);
      return v;
    } else if (value is int) {
      return value;
    }

    return defaultValue;
  }

  /// get double from a string/double, or return given default if value is not a valid double (no exception is raised)
  static double getDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;

    if (value is String) {
      var v = double.tryParse(value);
      return v != null ? v : defaultValue;
    } else if (value is int) {
      var v = value.toDouble();
    } else if (value is double) {
      return value;
    }

    return defaultValue;
  }

  /// get DateTime from a string, or return given default if value is not a valid DateTime (no exception is raised)
  static DateTime getDateTime(dynamic value, DateTime defaultValue) {
    if (value == null) return defaultValue;

    if (value is String) {
      try {
        var v = DateTime.parse(value);
        return v;
      } catch (e) {
        return defaultValue;
      }
    }

    return defaultValue;
  }

  /// get DateTime? from a string, or return given default if value is not a valid DateTime? (no exception is raised)
  static DateTime? getDateTimeNullable(dynamic value, DateTime? defaultValue) {
    if (value == null) return defaultValue;

    if (value is String) {
      try {
        var v = DateTime.parse(value);
        return v;
      } catch (e) {
        return defaultValue;
      }
    }

    return defaultValue;
  }

  /// get bool from a string/bool, or return given default if value is not a valid bool (no exception is raised)
  static bool getBool(dynamic value, bool defaultValue) {
    if (value == null) return defaultValue;

    if (value is String) {
      if (value == 'true')
        return true;
      else if (value == 'false') return false;
    } else if (value is bool) {
      return value;
    }

    return defaultValue;
  }

  static String colorToString(Color color) {
    return '#' + color.value.toRadixString(16);
  }

  /// convert string to color
  static Color colorFromString(dynamic color, Color defaultValue) {
    if (color == null || !(color is String)) return defaultValue;

    color = color.replaceAll('#', '');

    if (color.length == 6)
      color = "0xFF" + color;
    else if (color.length == 8)
      color = "0x" + color;
    else
      return defaultValue;

    return Color(getInt(color, 0));
  }

  /// convert string to color
  static Color? colorFromStringNullable(dynamic color, Color? defaultValue) {
    if (color == null || !(color is String)) return defaultValue;

    color = color.replaceAll('#', '');

    if (color.length == 6)
      color = "0xFF" + color;
    else if (color.length == 8)
      color = "0x" + color;
    else
      return defaultValue;

    return Color(getInt(color, 0));
  }

  /// parse unix time from a double float representation
  DateTime parseUnixTimef(dynamic jsn) {
    var timef = JsonUtils.getDouble(jsn, 0);

    var time = DateTime(1970, 1, 1);

    if (timef != 0) {
      time = DateTime.fromMillisecondsSinceEpoch((timef * 1000).toInt());
    }

    return time;
  }
}

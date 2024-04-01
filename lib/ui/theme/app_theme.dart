import 'package:flutter/material.dart';

class AppTheme {
  bool isDark = false;
  String name = '';
  late ThemeData theme;

  AppTheme({this.isDark = false, this.name = '', required this.theme});

  void construct() {}
}

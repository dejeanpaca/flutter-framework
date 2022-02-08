import 'package:flutter/material.dart';

class AppTheme {
  bool isDark = false;
  String name = '';
  late ThemeData theme;

  AppTheme({bool isDark = false, String name = '', required ThemeData theme}) {
    this.isDark = isDark;
    this.name = name;
    this.theme = theme;
  }

  void construct() {

  }
}

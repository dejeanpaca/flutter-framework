import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'dynamic_theme.dart';

class Themes {
  static const int THEME_LIGHT = 0;
  static const int THEME_DARK = 1;

  static String themePreference = 'system';

  static ThemeMode mode = ThemeMode.system;

  /// current app theme
  static AppTheme current = AppTheme(theme: ThemeData());

  /// current flutter theme
  static ThemeData theme = new ThemeData();

  /// is the current theme dark
  static bool isDark = false;

  /// list of themes used with theme indexes
  static List<AppTheme?> themes = [null, null];

  static List<Function> onApplyTheme = [];

  /// does the current device seem like a tablet
  static bool isTablet = false;

  /// determine initial state and parameters for the app
  static void initial(BuildContext context) {
    var shortestSide = MediaQuery
        .of(context)
        .size
        .shortestSide;

    isTablet = shortestSide >= 600;
  }

  /// get theme mode based on settings
  static ThemeMode getMode() {
    if (themePreference == 'system') return ThemeMode.system;

    if (themePreference == 'dark') return ThemeMode.dark;

    return ThemeMode.light;
  }

  /// get app theme index based on settings
  static int getAppThemeIndex({Brightness? brightness}) {
    if (themePreference == 'system') {
      if (brightness != null) {
        if (brightness == Brightness.light)
          return THEME_LIGHT;
        else if (brightness == Brightness.dark)
          return THEME_DARK;
      }

      return THEME_LIGHT;
    }

    if (themePreference == 'dark') return THEME_DARK;

    return THEME_LIGHT;
  }

  /// get app theme based on settings
  static AppTheme getAppTheme({Brightness? brightness}) {
    return themes[getAppThemeIndex(brightness: brightness)]!;
  }

  /// set theme with the given theme index
  static void setTheme(int themeIndex) {
    current = themes[themeIndex]!;
    theme = current.theme;
    isDark = (current.isDark);

    print('Theme set: ' + current.name);
  }

  /// apply current theme
  static void applyThemeFromPreference(BuildContext context) {
    var brightness = MediaQuery
        .of(context)
        .platformBrightness;

    var index = getAppThemeIndex(brightness: brightness);
    setTheme(index);
    applyTheme(context);
  }

  /// apply current theme
  static void applyTheme(BuildContext context) {
    DynamicThemeMode.of(context)!.setThemeData(theme);

    for (var f in onApplyTheme) {
      f();
    }
  }

  /// We use this method to set  which app theme we use for a given brightness.
  /// This may sometimes be required if we're using the `system` theme.
  static void setCurrentFromBrightness(Brightness brightness) {
    if (getMode() == ThemeMode.system) {
      var which = getAppThemeFromBrightness(brightness);
      setTheme(which);
    } else if (getMode() == ThemeMode.dark)
      setTheme(THEME_DARK);
    else
      setTheme(THEME_LIGHT);
  }

  /// We use this method to determine which app theme to use for a given brightness.
  /// This may sometimes be required if we're using the `system` theme to detect what app theme to use.
  static int getAppThemeFromBrightness(Brightness brightness) {
    if (brightness == Brightness.light)
      return THEME_LIGHT;
    else if (brightness == Brightness.dark) return THEME_DARK;

    return THEME_DARK;
  }

  static void toggleTheme() {
    if (themePreference == 'system')
      themePreference = 'light';
    else if (themePreference == 'light')
      themePreference = 'dark';
    else if (themePreference == 'dark') themePreference = 'system';
  }
}

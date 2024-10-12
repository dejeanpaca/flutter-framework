import 'package:flutter/material.dart';
import 'app_theme.dart';

typedef DynamicThemeDataWidgetBuilder = Widget Function(BuildContext context, AppTheme? theme);

typedef ThemeDataBuilder = AppTheme Function(AppTheme? theme);

class DynamicThemeMode extends StatefulWidget {
  const DynamicThemeMode({super.key, this.data, this.child});

  /// Builder that gets called when the theme mode changes
  final DynamicThemeDataWidgetBuilder? child;

  /// Callback that returns the latest theme
  final ThemeDataBuilder? data;

  @override
  DynamicThemeModeState createState() => DynamicThemeModeState();

  static DynamicThemeModeState? of(BuildContext context) {
    return context.findAncestorStateOfType<DynamicThemeModeState>();
  }
}

class DynamicThemeModeState extends State<DynamicThemeMode> {
  static AppTheme? theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = widget.data!(theme);
  }

  @override
  void didUpdateWidget(DynamicThemeMode oldWidget) {
    super.didUpdateWidget(oldWidget);
    theme = widget.data!(theme);
  }

  /// Set the theme mode using the provided theme data
  void setThemeData(AppTheme data) {
    setState(() {
      theme = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!(context, theme);
  }
}

import 'package:flutter/material.dart';

typedef DynamicThemeDataWidgetBuilder = Widget Function(BuildContext context, ThemeData? theme);

typedef ThemeDataBuilder = ThemeData Function(ThemeData? theme);

class DynamicThemeMode extends StatefulWidget {
  const DynamicThemeMode({Key? key, this.data, this.child}) : super(key: key);

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
  ThemeData? theme;

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
  void setThemeData(ThemeData data) {
    setState(() {
      theme = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!(context, theme);
  }
}

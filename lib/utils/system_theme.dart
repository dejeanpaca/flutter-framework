import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setSystemOverlayStyle({Color? navbarColor, Color? statusBarcolor = Colors.transparent}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: navbarColor,
    statusBarColor: statusBarcolor,
  ));
}

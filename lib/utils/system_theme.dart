import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setSystemOverlayStyle(Color color) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: color,
    statusBarColor: Colors.transparent,
   ));
}

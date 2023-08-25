import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../framework_config.dart';

void printException(error, StackTrace? stackStrace) {
  if(FlFrameworkConfig.printExceptions) {
    print(error);
    if (kDebugMode && stackStrace != null) debugPrintStack(stackTrace: stackStrace);
  }
}

void dismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

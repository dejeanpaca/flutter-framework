import 'dart:async';

import 'package:flutter/material.dart';

/// Helps to refresh state periodically
/// Instance it, run() it with a setState, and call .dispose() on dispose
class StateRefresher {
  Timer? timer;

  void run(StateSetter setState, {Duration duration = const Duration(seconds: 10)}) {
    if (timer != null) return;

    timer = Timer.periodic(duration, (Timer t) {
      setState(() {});
    });
  }

  /// should be called on page/widget dispose()
  void dispose() {
    timer?.cancel();
  }
}

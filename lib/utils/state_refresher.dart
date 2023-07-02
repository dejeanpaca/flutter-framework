import 'dart:async';

import 'package:flutter/material.dart';

/// Helps to refresh state periodically
/// Instance it, run() it with a setState, and call .dispose() on dispose
class StateRefresher {
  Timer? timer;
  Future<void> Function()? onRun;

  void run(StateSetter setState, {Duration duration = const Duration(seconds: 10), Future<void> Function()? onRun}) {
    if (timer != null) return;

    timer = Timer.periodic(duration, (Timer t) async {
      if (onRun != null) await onRun();
      setState(() {});
    });
  }

  /// should be called on page/widget dispose()
  void dispose() {
    timer?.cancel();
  }
}

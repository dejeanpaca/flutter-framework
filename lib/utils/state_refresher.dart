import 'dart:async';

import 'package:flutter/material.dart';

class StateRefresher {
  Timer? timer;

  void run(StateSetter setState, {Duration duration = const Duration(seconds: 10)}) {
    if (timer != null) return;

    timer = Timer.periodic(duration, (Timer t) {
      setState(() {});
    });
  }

  void dispose() {
    timer?.cancel();
  }
}

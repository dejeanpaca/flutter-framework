import 'dart:async';

class SingleFireFunction {
  static int appInstance = 0;

  bool fired = false;
  bool done = false;
  int instance = 0;

  void fire(Future<void> Function() onFire, {bool refire = false}) {
    if (refire) {
      fired = false;
      done = false;
    }

    if (appInstance != instance) {
      instance = appInstance;
      fired = false;
      done = false;
    }

    if (!fired) {
      fired = true;

      Timer.run(() async {
        await onFire();
        done = true;
      });
    }
  }
}

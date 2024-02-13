import 'dart:async';

class SingleFireFunction {
  static int appInstance = 0;

  bool fired = false;
  bool done = false;
  int instance = 0;

  Future<void> Function()? onFire;

  /// Run a given function.
  /// [refire] can force to run again (may run concurrently if not [done])
  void fire(Future<void> Function() onFire, {bool refire = false}) {
    this.onFire = onFire;

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

  /// fire function again if it is fired at least once, and alread done
  void fireAgain({Future<void> Function()? onFire}) {
    if (this.onFire == null && onFire != null) {
      this.onFire = onFire;
    }

    if (done && this.onFire != null) {
      fire(this.onFire!, refire: true);
    }
  }
}

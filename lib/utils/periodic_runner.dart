/// Runs a method in periodic manner when indicated to do so.<br/>
/// Simple (poor mans) background jobs.
class PeriodicRunner {
  /// last time we ran
  DateTime lastRunTime = DateTime.now();

  /// can we run in this cycle
  bool canRun = false;

  /// run every cycle irregardless of [canRun]
  bool runAlways = false;

  /// run while this is true, otherwise [run] method will quit
  bool running = true;

  /// run every X milliseconds if changed
  Duration runEvery = const Duration(milliseconds: 2500);

  /// how long to wait between cycles
  Duration cycleWait = const Duration(milliseconds: 500);

  /// called when we can run
  Future<void> onRun() async {}

  /// run cycles
  Future<void> run() async {
    lastRunTime = DateTime.now().subtract(runEvery);

    while (running) {
      if (running) await Future.delayed(cycleWait);

      var now = DateTime.now();

      if (canRun || runAlways) {
        if (now.difference(lastRunTime).inMilliseconds < runEvery.inMilliseconds) continue;

        await onRun();

        if (!runAlways) canRun = false;
        lastRunTime = DateTime.now();
      }
    }
  }
}

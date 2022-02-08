import 'dart:io';
import 'package:framework/utils/storage.dart';

/// Data store manages the important user data (the things which we want to keep)
class DataStore {
  /// current data store version
  static const int Version = 1;

  /// loaded data store version
  static int storedVersion = 0;

  static String getPath() {
    return documentsPath + '/data';
  }

  static Future<bool> dataStorePathExists() async {
    var path = getPath();
    var d = Directory(path);

    return await d.exists();
  }

  static Future<bool> createDataStorePath() async {
    var path = getPath();
    var d = Directory(path);

    if (await d.exists() == false) {
      try {
        await d.create();

        print('Created data store path: ' + path);

        return true;
      } catch (e) {
        print('Failed to create data store path: ' + path);
        print(e.toString());
      }

      // failed to create directory
      return false;
    }

    // directory already exists
    return true;
  }
}

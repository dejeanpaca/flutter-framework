import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:framework/utils/storage.dart';

/// Data store manages the important user data (the things which we want to keep)
class DataStore {
  /// current data store version
  static const int Version = 1;

  /// loaded data store version
  static int storedVersion = 0;

  /// data path within the base path
  static String dataPath = '/data';

  /// base path where we store files
  static String basePath = '';

  /// base path where we store files
  static String getPath() {
    if (basePath.isEmpty) return libraryPath + dataPath;

    return basePath + dataPath;
  }

  /// does the data store path exists
  static Future<bool> pathExists() async {
    var path = getPath();
    var d = Directory(path);

    return await d.exists();
  }

  /// creates the data store path
  static Future<bool> createPath() async {
    var path = getPath();
    var d = Directory(path);

    if (d.existsSync() == false) {
      try {
        d.createSync();

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

  /// deletes all files from the data store
  static Future<void> clear() async {
    // delete data store
    var d = Directory(DataStore.getPath());

    if (await d.exists()) await d.delete(recursive: true);
  }
}

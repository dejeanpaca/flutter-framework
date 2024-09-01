import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:framework/utils/storage.dart';
import 'package:path/path.dart' as path;

/// Data store manages the important user data (the things which we want to keep)
class DataStore {
  /// current data store version
  static const int Version = 1;

  /// loaded data store version
  static int storedVersion = 0;

  /// data path within the base path
  static String dataPath = 'data';

  /// base path where we store files (excluding trailing slash)
  static String basePath = '';

  /// base path where we store all files
  static String getBasePath() {
    if (basePath.isEmpty) return libraryPath;

    return basePath;
  }

  /// path where we store data files
  static String getPath() {
    if (basePath.isEmpty) return path.join(libraryPath, dataPath);

    return path.join(basePath, dataPath);
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

    if (kDebugMode) print('data store > exists at: ' + path);

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

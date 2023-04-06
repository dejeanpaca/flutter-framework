import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:framework/utils/json_storage.dart' as jsonStorage;
import 'package:framework/utils/storage.dart';

import 'data_store.dart';

class StoredFile {
  /// log verbose
  static bool logVerbose = false;

  /// name for this file (not the path)
  String fileName = 'file.json';

  StoredFile();

  /// get the storage path for this file
  String getPath() {
    return documentsPath + '/$fileName';
  }

  /// convert to json
  Map<String, dynamic> toJson() => {};

  /// read json
  void loadJson(Map<String, dynamic> jsn) {}

  /// save this file
  Future<bool> save() async {
    return await saveFile(this);
  }

  /// save this file
  Future<bool> saveFile<T>(T what) async {
    var filePath = getPath();

    // just write the file
    var ok = await jsonStorage.saveJson(filePath, what, logVerbose: logVerbose);

    return ok;
  }

  /// called only when the json file is loaded
  Future<void> onLoad(Map<String, dynamic> json) async {
    loadJson(json);
  }

  /// load this file
  Future<void> load() async {
    var json = await jsonStorage.loadJson(getPath(), logVerbose: logVerbose);

    if (json != null) await onLoad(json);
  }

  /// delete the stored file managed by this handler
  Future<bool> exists() async {
    var f = File(getPath());
    return await f.exists();
  }

  /// delete the stored file managed by this handler
  Future<bool> delete() async {
    // delete file
    var f = File(getPath());

    if (await f.exists()) {
      try {
        await f.delete();
        print('Deleted file: ${f.path}');
      } catch (e) {
        print('Failed to delete file: ${f.path}');
        return false;
      }
    }

    return true;
  }
}

/// Data file that is part of the data store
class StoredDataFile extends StoredFile {
  @override
  String getPath() {
    return DataStore.getPath() + '/$fileName';
  }

  @override
  Future<bool> delete() async {
    if (await DataStore.pathExists()) {
      return await super.delete();
    }

    return true;
  }
}

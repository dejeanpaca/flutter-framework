import 'dart:io';

import 'package:framework/utils/json_storage.dart' as jsonStorage;
import 'package:framework/utils/storage.dart';

import 'data_store.dart';

class StoredFile {
  /// log verbose
  static bool logVerbose = false;

  /// write files in a safe way
  static bool safeWrite = true;

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
  loadJson(Map<String, dynamic> jsn) {}

  /// save this file
  Future<void> save() async {
    await saveFile(this);
  }

  /// save this file
  Future<bool> saveFile<T>(T what) async {
    var filePath = getPath();

    // just write the file
    if (!safeWrite) {
      return await jsonStorage.saveJson(filePath, what, logVerbose: logVerbose);
    }

    // store new file
    var ok = await jsonStorage.saveJson(filePath + '.new', what, logVerbose: logVerbose);

    if (!ok) return false;

    // rename old file, if one is present
    var oldF = File(filePath);

    if (await oldF.existsSync()) {
      File? f;

      try {
        await oldF.rename(filePath + '.old');
        ok = true;
      } catch (e) {
        print('Failed to rename old file: $filePath to $filePath.old');
        print(e);
        return false;
      };
    }

    // rename new file to target file
    var newF = File(filePath + '.new');

    try {
      await newF.rename(filePath);
      ok = true;
    } catch (e) {
      print('Failed to rename new file: $filePath.new to $filePath');
      print(e);
      return false;
    }

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
  Future<bool> deleteFile() async {
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
  Future<bool> deleteFile() async {
    if (await DataStore.pathExists()) {
      return await super.deleteFile();
    }

    return true;
  }
}

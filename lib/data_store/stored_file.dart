import 'dart:io';

import 'package:framework/utils/json_storage.dart';
import 'package:framework/utils/storage.dart';
import 'data_store.dart';

class StoredFile {
  String fileName = 'file.json';

  StoredFile();

  String getPath() {
    return documentsPath + '/$fileName';
  }

  /// convert from json to object
  StoredFile.fromJson(Map<String, dynamic> jsn);

  /// convert to json
  Map<String, dynamic> toJson() => {};

  /// save this file
  Future<void> save() async {}

  /// save this file
  Future<bool> saveFile<T>(T what) async {
    return await saveJson(getPath(), what);
  }

  /// called only when the json file is loaded
  Future<void> onLoad(Map<String, dynamic> json) async {}

  /// load this file
  Future<void> load() async {
    var json = await loadJson(getPath());

    if (json != null) onLoad(json);
  }

  /// delete the stored file managed by this handler
  Future<void> deleteFile() async {
    // delete file
    var f = File(getPath());

    if (await f.exists()) {
      try {
        await f.delete();
        print('Deleted file: ${f.path}');
      } catch (e) {
        print('Failed to delete file: ${f.path}');
      }
    }
  }
}

/// Data file that is part of the data store
class StoredDataFile extends StoredFile {
  @override
  String getPath() {
    return DataStore.getPath() + '/$fileName';
  }

  @override
  Future<void> deleteFile() async {
    if (await DataStore.dataStorePathExists()) {
      await super.deleteFile();
    }
  }
}

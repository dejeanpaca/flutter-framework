import 'dart:io';
import 'misc.dart';
import 'package:flutter/services.dart';

Future<bool> copyFile(File file, String to) async {
  if (await file.exists()) {
    try {
      await file.copy(to);
    } catch (e, s) {
      printException(e, s);
      return false;
    }
  }

  return true;
}

Future<String> readFileAsString(String path) async {
  try {
    var f = File(path);

    if (f.existsSync()) {
      var content = f.readAsString();

      return content;
    }
  } catch (e, s) {
    printException(e, s);
  }

  return '';
}

Future<String> saveStringToFile({required String path, required String content}) async {
  try {
    var f = File(path);

    f.writeAsString(content);
  } catch (e, s) {
    printException(e, s);
  }

  return '';
}

Future<String> loadAssetFileAsString(String path) async {
  try {
    var file = await rootBundle.loadString(path, cache: false);

    return file;
  } catch (e) {
    // ignore
  }

  return '';
}

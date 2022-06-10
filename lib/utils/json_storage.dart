import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>?> loadJson(String fileName, {bool logVerbose = false}) async {
  File file = new File(fileName);

  Map<String, dynamic>? result;

  if (await file.exists() == false) {
    if (logVerbose) print('load > Does not exist: ' + fileName);
    return null;
  }

  try {
    var s = await file.readAsString();

    result = json.decode(s);

    if (logVerbose) print('load > json: ' + fileName);
  } catch (e) {
    result = null;
    if (logVerbose) print('load > failed: ' + fileName);
    print(e.toString());
  }

  return result;
}

Future<bool> saveJson<T>(String fileName, T what, {bool logVerbose = false}) async {
  File file = new File(fileName);

  bool result;

  try {
    var contents = json.encode(what);

    file.writeAsString(contents);

    if (logVerbose) print('save > json: ' + fileName + ' as ' + T.toString());
    result = true;
  } catch (e, s) {
    if (logVerbose) print('save > failed: ' + fileName);
    print(e.toString());
    debugPrintStack(stackTrace: s);

    result = false;
  }

  return result;
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>?> loadJson(String fileName, {bool logVerbose = false}) async {
  File file = File(fileName);

  Map<String, dynamic>? result;

  if (await file.exists() == false) {
    if (logVerbose) print('load > Does not exist: ' + fileName);
    return null;
  }

  try {
    var s = await file.readAsString();

    if (s.isNotEmpty) {
      result = json.decode(s);

      if (logVerbose) print('load > json: ' + fileName);
    } else {
      if (logVerbose) print('load > json empty: ' + fileName);
    }
  } catch (e) {
    result = null;
    if (logVerbose) print('load > failed: ' + fileName);
    print(e.toString());
  }

  return result;
}

Future<bool> saveJson<T>(String fileName, T what, {bool logVerbose = false, bool flush = true}) async {
  bool result = false;
  String contents = '';

  try {
    contents = json.encode(what);
  } catch (e, s) {
    if (logVerbose) print('save > failed to encode: ' + fileName);
    print(e.toString());
    debugPrintStack(stackTrace: s);

    return false;
  }

  File file = File(fileName);

  if (contents.isNotEmpty) {
    try {
      await file.writeAsString(contents, flush: flush);

      if (logVerbose) print('save > json: ' + fileName + ' as ' + T.toString());

      result = true;
    } catch (e, s) {
      if (logVerbose) print('save > failed: ' + fileName);
      print(e.toString());
      debugPrintStack(stackTrace: s);

      result = false;
    }
  }

  return result;
}

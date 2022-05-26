import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

var documentsPath = '';
var temporaryPath = '';

Future<void> setupPaths() async {
  var dir = await getApplicationDocumentsDirectory();
  documentsPath = dir.path;

  dir = await getTemporaryDirectory();
  temporaryPath = dir.path;

  print('Documents path: ' + documentsPath);
  print('Temporary files path: ' + temporaryPath);
}

/// delete the given file and prevent exceptions
Future<bool> deleteFile(path) async {
  var ok = false;

  var f = File(path);

  try {
    await f.delete();
    ok = true;
  } catch (e) {

  }

  return ok;
}

Future<bool> saveFileAsString(String fileName, String contents) async {
  final File file = File(fileName);

  bool result;

  try {
    file.writeAsString(contents, flush: true);

    result = true;
  } catch (e) {
    print(e.toString());

    result = false;
  }

  return result;
}

Future<bool> saveFileAsBytes(String fileName, Uint8List bytes) async {
  final File file = File(fileName);

  bool result;

  try {
    file.writeAsBytes(bytes, flush: true);

    result = true;
  } catch (e) {
    print(e.toString());

    result = false;
  }

  return result;
}

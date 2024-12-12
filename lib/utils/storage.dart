import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// where do we store documents
var documentsPath = '';

/// for other platforms than ios/macos this equates to documentsPath
var libraryPath = '';

/// temporary storage path
var temporaryPath = '';

Future<void> setupPaths() async {
  var dir = await getApplicationDocumentsDirectory();
  documentsPath = dir.path;

  if (Platform.isIOS || Platform.isMacOS) {
    dir = await getLibraryDirectory();
    libraryPath = dir.path;
  } else {
    libraryPath = documentsPath;
  }

  dir = await getTemporaryDirectory();
  temporaryPath = dir.path;

  if (kDebugMode) {
    print('storage > Documents path: $documentsPath');
    if (documentsPath != libraryPath) print('storage > Library path: $libraryPath');
    print('storage > Temporary files path: $temporaryPath');
  }
}

/// delete the given file and prevent exceptions
Future<bool> deleteFile(path) async {
  var ok = false;

  var f = File(path);

  try {
    await f.delete();
    ok = true;
  } catch (e) {
    ok = false;
  }

  return ok;
}

/// remove a directory with the given path
Future<bool> removeDirectory(String path) async {
  bool ok = false;

  // remove old contents (if any)
  try {
    var dir = Directory(path);

    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }

    ok = true;
  } catch (e) {
    ok = false;
  }

  return ok;
}


Future<bool> saveFileAsString(String fileName, String contents) async {
  final File file = File(fileName);

  bool result;

  try {
    await file.writeAsString(contents, flush: true);

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
    await file.writeAsBytes(bytes, flush: true);

    result = true;
  } catch (e) {
    print(e.toString());

    result = false;
  }

  return result;
}

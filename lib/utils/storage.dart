import 'dart:io';
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

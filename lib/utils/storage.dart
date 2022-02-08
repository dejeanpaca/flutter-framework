import 'dart:io';

var documentsPath = '';
var temporaryPath = '';

Future<void> setupPaths() async {
  documentsPath = await getDocumentsPath();
  var dir = await getTemporaryDirectory();
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

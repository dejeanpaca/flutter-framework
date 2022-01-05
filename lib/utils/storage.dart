import 'dart:io';

var documentsPath = '';
var temporaryPath = '';

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

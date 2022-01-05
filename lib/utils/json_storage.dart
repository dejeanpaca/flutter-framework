import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>?> loadJson(String fileName) async {
  File file = new File(fileName);

  Map<String, dynamic>? result;

  if (await file.exists() == false) {
    print('load > Does not exist: ' + fileName);
    return null;
  }

  try {
    var s = await file.readAsString();

    result = json.decode(s);

    print('load > json: ' + fileName);
  } catch (e) {
    result = null;
    print('load > failed: ' + fileName);
    print(e.toString());
  }

  return result;
}

Future<bool> saveJson<T>(String fileName, T what) async {
  File file = new File(fileName);

  bool result;

  try {
    var contents = json.encode(what);

    file.writeAsString(contents);

    print('save > json: ' + fileName + ' as ' + T.toString());
    result = true;
  } catch (e) {
    print('save > failed: ' + fileName);
    print(e.toString());

    result = false;
  }

  return result;
}

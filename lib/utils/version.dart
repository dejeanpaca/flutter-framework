import 'dart:math';

/// parse versions in format XX.XX.XX.XX ... as a list of integers
List<int> parseVersion(String version) {
  List<int> versions = [];

  var strings = version.split('.');

  for (var i = 0; i < strings.length; ++i) {
    var v = int.tryParse(strings[i]);
    if (v != null) {
      versions.add(v);
    } else {
      versions.add(0);
    }
  }

  return versions;
}

/// compare two versions in format XX.XX.XX
int compareVersions(List<int> a, List<int> b) {
  var maximum = max(a.length, b.length);

  for (var i = 0; i < maximum; ++i) {
    var va = i < a.length ? a[i] : 0;
    var vb = i < b.length ? b[i] : 0;

    var comp = va.compareTo(vb);
    if (comp != 0) return comp;
  }

  return 0;
}

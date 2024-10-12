extension StringUtils on String {
  bool equalCaseInsensitive(String other) {
    return toLowerCase() == other.toLowerCase();
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

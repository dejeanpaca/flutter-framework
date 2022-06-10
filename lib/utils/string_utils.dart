extension StringUtils on String {
  bool equalCaseInsensitive(String other) {
    return this.toLowerCase() == other.toLowerCase();
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

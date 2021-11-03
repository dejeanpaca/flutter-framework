extension StringUtils on String {
  bool equalCaseInsensitive(String other) {
    return this.toLowerCase() == other.toLowerCase();
  }
}

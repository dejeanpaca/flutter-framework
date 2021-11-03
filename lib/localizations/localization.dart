class Localization {
  static Localization current = new Localization();

  String getOrderNumber(int number) {
    return number.toString();
  }

  String getDayOfMonth(int number) {
    return getOrderNumber(number);
  }
}

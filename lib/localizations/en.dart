import 'localization.dart';

class EnLocalization extends Localization {
  @override
  String getOrderNumber(int number) {
    int lastDecimal = number % 10;
    int lastTwoDecimals = number % 100;

    if (lastTwoDecimals == 11 || lastTwoDecimals == 12 || lastTwoDecimals == 13) return number.toString() + 'th';

    if (lastDecimal == 0)
      return number.toString() + 'th';
    else if (lastDecimal == 1)
      return number.toString() + 'st';
    else if (lastDecimal == 2)
      return number.toString() + 'nd';
    else if (lastDecimal == 3) return number.toString() + 'rd';

    return number.toString() + 'th';
  }
}

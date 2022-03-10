import 'package:flutter/widgets.dart';

/// A helpful way to handle sizes in flutter according to:
/// https://medium.com/flutter-community/flutter-effectively-scale-ui-according-to-different-screen-sizes-2cb7c115ea0a

class SizeConfig {
  static late MediaQueryData mediaQuery;

  static double blockSize = 100;

  static double screenWidth = 1.0;
  static double screenHeight = 1.0;
  static double aspectRatio = 1.0;

  static double blockSizeHorizontal = 1.0;
  static double blockSizeVertical = 1.0;

  static double safeAreaHorizontal = 1.0;
  static double safeAreaVertical = 1.0;
  static double safeBlockHorizontal = 1.0;
  static double safeBlockVertical = 1.0;

  static void initialize(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    blockSizeHorizontal = screenWidth / blockSize;
    blockSizeVertical = screenHeight / blockSize;
    aspectRatio = screenWidth / screenHeight;

    safeAreaHorizontal = mediaQuery.padding.left + mediaQuery.padding.right;
    safeAreaVertical = mediaQuery.padding.top + mediaQuery.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / blockSize;
    safeBlockVertical = (screenHeight - safeAreaVertical) / blockSize;

    print('Screen aspect ratio: $aspectRatio');
    print('Screen size: ${screenWidth}x$screenHeight');
    print('Safe area: ${safeAreaHorizontal}x$safeBlockVertical');
  }
}

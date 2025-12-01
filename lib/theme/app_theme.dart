import 'package:flutter/cupertino.dart';

class AppTheme {
  // Màu primary app
  static const primaryColor = Color(0xFFFF9114);

  // LIGHT THEME
  static final light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFFF4F2E7),
    textTheme: const CupertinoTextThemeData(
      // Body text dùng Open Sans
      textStyle: TextStyle(
        fontFamily: "Open Sans",
        color: CupertinoColors.black,
      ),
      // Heading / Nav title dùng Nunito Sans
      navTitleTextStyle: TextStyle(
        fontFamily: "Nunito",
        color: CupertinoColors.black,
      ),
      // Action button / Large title
      actionTextStyle: TextStyle(fontFamily: "Nunito", fontSize: 20),
      // Tab / Label
      tabLabelTextStyle: TextStyle(
        fontFamily: "Open Sans",
        color: CupertinoColors.black,
      ),
    ),
  );

  // DARK THEME
  static final dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF131313),
    textTheme: const CupertinoTextThemeData(
      textStyle: TextStyle(
        fontFamily: "Open Sans",
        color: CupertinoColors.white,
      ),
      navTitleTextStyle: TextStyle(
        fontFamily: "Nunito",
        color: CupertinoColors.white,
      ),
      actionTextStyle: TextStyle(fontFamily: "Nunito", fontSize: 18),
      tabLabelTextStyle: TextStyle(
        fontFamily: "Open Sans",
        color: CupertinoColors.white,
      ),
    ),
  );

  // Lấy theme dựa vào isDark
  static CupertinoThemeData theme(bool isDark) => isDark ? dark : light;
}

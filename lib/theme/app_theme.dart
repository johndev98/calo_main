import 'package:flutter/cupertino.dart';

class AppTheme {
  // Màu primary app
  static const primaryColor = Color(0xffff9114);

  // LIGHT THEME
  static final light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xfff4f2e7),
    textTheme: const CupertinoTextThemeData(
      // Body text dùng Open Sans
      textStyle: TextStyle(
        fontFamily: "Open Sans",
        color: CupertinoColors.black,
        fontSize: 16,
      ),
      // Heading / Nav title dùng Nunito Sans
      navTitleTextStyle: TextStyle(
        fontFamily: "Nunito",
        color: CupertinoColors.black,
        fontSize: 20,
      ),
      // Action button / Large title
      actionTextStyle: TextStyle(fontFamily: "Nunito", fontSize: 18),
      // Tab / Label
      tabLabelTextStyle: TextStyle(
        fontFamily: "Open Sans",
        color: CupertinoColors.black,
        fontSize: 12,
      ),
    ),
  );

  // DARK THEME
  static final dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xff131313),
    textTheme: const CupertinoTextThemeData(
      textStyle: TextStyle(
        fontFamily: "Open Sans",
        color: CupertinoColors.white,
        fontSize: 16,
      ),
      navTitleTextStyle: TextStyle(
        fontFamily: "Nunito",
        color: CupertinoColors.white,
        fontSize: 20,
      ),
      actionTextStyle: TextStyle(fontFamily: "Nunito", fontSize: 18),
      tabLabelTextStyle: TextStyle(
        fontFamily: "Open Sans",
        color: CupertinoColors.white,
        fontSize: 12,
      ),
    ),
  );

  // Lấy theme dựa vào isDark
  static CupertinoThemeData theme(bool isDark) => isDark ? dark : light;
}

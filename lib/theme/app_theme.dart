import 'package:flutter/cupertino.dart';
import 'package:mix/mix.dart';

class AppTheme {
  static const primaryColor = Color(0xFFFF9114);

  // ========== MIX DESIGN TOKENS ==========

  static final $primary = ColorToken('primary');
  static final $background = ColorToken('background');
  static final $surface = ColorToken('surface');
  static final $textPrimary = ColorToken('textPrimary');
  static final $textSecondary = ColorToken('textSecondary');
  static final $border = ColorToken('border');
  static final $gradient1 = ColorToken('gradient1');
  static final $gradient2 = ColorToken('gradient2');

  static final $heading = TextStyleToken('heading');
  static final $body = TextStyleToken('body');
  static final $actionText = TextStyleToken('actionText');
  static final $textButton = TextStyleToken('textButton');
  static final $label = TextStyleToken('label');

  static final $spacing = SpaceToken('spacing');
  static final $spacingSmall = SpaceToken('spacing.small');
  static final $spacingMedium = SpaceToken('spacing.medium');
  static final $spacingLarge = SpaceToken('spacing.large');

  // Radius Tokens - Hierarchy
  static final $radiusNone = RadiusToken('radius.none');
  static final $radiusSmall = RadiusToken('radius.small');
  static final $radiusMedium = RadiusToken('radius.medium');
  static final $radiusLarge = RadiusToken('radius.large');
  static final $radiusXLarge = RadiusToken('radius.xlarge');
  static final $radiusFull = RadiusToken('radius.full');

  // ========== LIGHT THEME ==========
  static MixThemeData lightMix() {
    return MixThemeData(
      colors: {
        $primary: primaryColor,
        $background: const Color(0xFFF7F4E9),
        $surface: CupertinoColors.white,
        $textPrimary: CupertinoColors.black,
        $textSecondary: const Color(0xFF757575),
        $border: const Color(0xFFE0E0E0),
        $gradient1: const Color(0xFFFFA726),
        $gradient2: const Color(0xFFFF7043),
      },
      textStyles: {
        $heading: const TextStyle(
          fontFamily: "Open Sans",
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xD0000000),
        ),
        $body: const TextStyle(
          fontFamily: "Open Sans",
          fontSize: 16,
          color: CupertinoColors.black,
        ),
        $textButton: const TextStyle(
          fontFamily: "Nunito",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
        $actionText: const TextStyle(
          fontFamily: "Nunito",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xA0000000),
        ),
        $label: const TextStyle(
          fontFamily: "Open Sans",
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xA6000000),
        ),
      },
      spaces: {
        $spacing: 24.0,
        $spacingSmall: 10.0,
        $spacingMedium: 20.0,
        $spacingLarge: 40.0,
      },
      radii: {
        $radiusNone: Radius.zero,
        $radiusSmall: const Radius.circular(8),
        $radiusMedium: const Radius.circular(12),
        $radiusLarge: const Radius.circular(15),
        $radiusXLarge: const Radius.circular(20),
        $radiusFull: const Radius.circular(9999),
      },
    );
  }

  // ========== DARK THEME ==========
  static MixThemeData darkMix() {
    return MixThemeData(
      colors: {
        $primary: primaryColor,
        $background: const Color(0xFF131313),
        $surface: const Color(0xFF1E1E1E),
        $textPrimary: CupertinoColors.white,
        $textSecondary: const Color(0xFFB0B0B0),
        $border: const Color(0xFF424242),
        $gradient1: const Color(0xFFFFA726),
        $gradient2: const Color(0xFFFF7043),
      },
      textStyles: {
        $heading: const TextStyle(
          fontFamily: "Open Sans",
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.white,
        ),
        $body: const TextStyle(
          fontFamily: "Open Sans",
          fontSize: 16,
          color: CupertinoColors.white,
        ),
        $actionText: const TextStyle(
          fontFamily: "Nunito",
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xA0000000),
        ),
        $textButton: const TextStyle(
          fontFamily: "Nunito",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
        $label: const TextStyle(
          fontFamily: "Open Sans",
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: CupertinoColors.white,
        ),
      },
      spaces: {
        $spacing: 24.0,
        $spacingSmall: 10.0,
        $spacingMedium: 20.0,
        $spacingLarge: 40.0,
      },
      radii: {
        $radiusNone: Radius.zero,
        $radiusSmall: const Radius.circular(8),
        $radiusMedium: const Radius.circular(12),
        $radiusLarge: const Radius.circular(15),
        $radiusXLarge: const Radius.circular(20),
        $radiusFull: const Radius.circular(9999),
      },
    );
  }

  // ========== CUPERTINO THEME (chỉ cho system widgets) ==========
  // CupertinoAlertDialog, CupertinoPicker, etc. vẫn cần CupertinoTheme
  static CupertinoThemeData cupertinoTheme(bool isDark) {
    return CupertinoThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF131313)
          : const Color(0xFFF7F4E9),
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          fontFamily: "Open Sans",
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
        ),
        actionTextStyle: TextStyle(
          fontFamily: "Nunito",
          fontSize: 17,
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
        ),
      ),
    );
  }

  static MixThemeData mixTheme(bool isDark) => isDark ? darkMix() : lightMix();
}

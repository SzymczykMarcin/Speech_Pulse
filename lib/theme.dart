import 'package:flutter/material.dart';

class PulseColors {
  static const background = Color(0xff131313);
  static const surface = Color(0xff201f1f);
  static const surfaceLow = Color(0xff1c1b1b);
  static const surfaceHigh = Color(0xff2a2a2a);
  static const surfaceVariant = Color(0xff353534);
  static const primary = Color(0xffffe2ab);
  static const primaryContainer = Color(0xffffbf00);
  static const onPrimary = Color(0xff402d00);
  static const secondary = Color(0xff71d7cd);
  static const onSurface = Color(0xffe5e2e1);
  static const onSurfaceVariant = Color(0xffd4c5ab);
  static const outline = Color(0xff504532);
  static const error = Color(0xffffb4ab);
}

ThemeData buildPulseTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: PulseColors.primary,
    brightness: brightness,
    primary: PulseColors.primary,
    secondary: PulseColors.secondary,
    error: dark ? PulseColors.error : Colors.red.shade700,
    surface: dark ? PulseColors.background : const Color(0xfff8f5ef),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor:
        dark ? PulseColors.background : const Color(0xfff8f5ef),
    fontFamily: 'Inter',
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: dark ? PulseColors.background : const Color(0xfff8f5ef),
      foregroundColor: dark ? PulseColors.primary : const Color(0xff402d00),
      titleTextStyle: TextStyle(
        color: dark ? PulseColors.primary : const Color(0xff402d00),
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      color: dark ? PulseColors.surface : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: dark ? Colors.white10 : Colors.black12,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        enableFeedback: false,
        minimumSize: const Size(0, 48),
        backgroundColor: PulseColors.primary,
        foregroundColor: PulseColors.onPrimary,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        enableFeedback: false,
        minimumSize: const Size(0, 48),
        foregroundColor: PulseColors.secondary,
        side: const BorderSide(color: PulseColors.secondary),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(enableFeedback: false),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(enableFeedback: false),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(enableFeedback: false),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? PulseColors.surfaceLow : Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PulseColors.primary, width: 2),
      ),
    ),
  );
}

class PulseText {
  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: PulseColors.onSurfaceVariant,
  );
}

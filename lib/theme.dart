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

  static const lightBackground = Color(0xfff7f2e8);
  static const lightSurface = Color(0xfffffbf3);
  static const lightSurfaceHigh = Color(0xffefe3d1);
  static const lightSurfaceVariant = Color(0xffe4d5bd);
  static const lightPrimary = Color(0xffd49300);
  static const lightPrimaryContainer = Color(0xffffc940);
  static const lightSecondary = Color(0xff006d66);
  static const lightOnSurface = Color(0xff211b12);
  static const lightOnSurfaceVariant = Color(0xff67553b);
  static const lightOutline = Color(0xffa99370);
  static const lightError = Color(0xffb3261e);
}

ThemeData buildPulseTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final background =
      dark ? PulseColors.background : PulseColors.lightBackground;
  final primary = dark ? PulseColors.primary : PulseColors.lightPrimary;
  final secondary = dark ? PulseColors.secondary : PulseColors.lightSecondary;
  final onSurface = dark ? PulseColors.onSurface : PulseColors.lightOnSurface;
  final outline = dark ? Colors.white10 : const Color(0x33000000);
  final scheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: brightness,
    primary: primary,
    onPrimary: PulseColors.onPrimary,
    secondary: secondary,
    onSecondary: dark ? PulseColors.background : Colors.white,
    error: dark ? PulseColors.error : PulseColors.lightError,
    surface: background,
    onSurface: onSurface,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    fontFamily: 'Inter',
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: background,
      foregroundColor: primary,
      titleTextStyle: TextStyle(
        color: primary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      color: dark ? PulseColors.surface : PulseColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: outline),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        enableFeedback: false,
        minimumSize: const Size(0, 48),
        backgroundColor: primary,
        foregroundColor: PulseColors.onPrimary,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        enableFeedback: false,
        minimumSize: const Size(0, 48),
        foregroundColor: secondary,
        side: BorderSide(color: secondary, width: 1.4),
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
      fillColor: dark ? PulseColors.surfaceLow : PulseColors.lightSurface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primary, width: 2),
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

extension PulseThemeColors on BuildContext {
  bool get isPulseDark => Theme.of(this).brightness == Brightness.dark;

  Color get pulseBackground =>
      isPulseDark ? PulseColors.background : PulseColors.lightBackground;

  Color get pulseSurface =>
      isPulseDark ? PulseColors.surface : PulseColors.lightSurface;

  Color get pulseSurfaceHigh =>
      isPulseDark ? PulseColors.surfaceHigh : PulseColors.lightSurfaceHigh;

  Color get pulseSurfaceVariant => isPulseDark
      ? PulseColors.surfaceVariant
      : PulseColors.lightSurfaceVariant;

  Color get pulsePrimary =>
      isPulseDark ? PulseColors.primary : PulseColors.lightPrimary;

  Color get pulsePrimaryContainer => isPulseDark
      ? PulseColors.primaryContainer
      : PulseColors.lightPrimaryContainer;

  Color get pulseSecondary =>
      isPulseDark ? PulseColors.secondary : PulseColors.lightSecondary;

  Color get pulseOnSurface =>
      isPulseDark ? PulseColors.onSurface : PulseColors.lightOnSurface;

  Color get pulseOnSurfaceVariant => isPulseDark
      ? PulseColors.onSurfaceVariant
      : PulseColors.lightOnSurfaceVariant;

  Color get pulseOutline =>
      isPulseDark ? PulseColors.outline : PulseColors.lightOutline;

  Color get pulsePanelBorder =>
      isPulseDark ? Colors.white10 : const Color(0x33000000);

  Color get pulseError =>
      isPulseDark ? PulseColors.error : PulseColors.lightError;

  TextStyle get pulseSectionLabel => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: pulseOnSurfaceVariant,
      );
}

import 'package:flutter/material.dart';

/// Warna semantik app. Nilai berubah mengikuti brightness tema aktif.
/// [apply] dipanggil oleh MaterialApp builder sebelum subtree dibangun.
class AppColors {
  static bool _isLight = false;

  static void apply(Brightness brightness) {
    _isLight = brightness == Brightness.light;
  }

  static bool get isLight => _isLight;

  static Color get bg =>
      _isLight ? const Color(0xFFF9F9FF) : const Color(0xFF080C12);
  static Color get surface =>
      _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF111823);
  static Color get surfaceLowest =>
      _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF111823);
  static Color get surfaceLow =>
      _isLight ? const Color(0xFFF0F3FF) : const Color(0xFF161F2D);
  static Color get surfaceAlt =>
      _isLight ? const Color(0xFFE7EEFF) : const Color(0xFF1A2433);
  static Color get surfaceHigh =>
      _isLight ? const Color(0xFFDEE8FF) : const Color(0xFF222E40);
  static Color get surfaceVariant =>
      _isLight ? const Color(0xFFD8E3FB) : const Color(0xFF2B374C);

  static Color get text =>
      _isLight ? const Color(0xFF111C2D) : const Color(0xFFF3F6FB);
  static Color get muted =>
      _isLight ? const Color(0xFF444654) : const Color(0xFF9AA9BE);
  static Color get outline =>
      _isLight ? const Color(0xFF757686) : const Color(0xFF8494AC);
  static Color get line =>
      _isLight ? const Color(0x14000000) : const Color(0x14FFFFFF);
  static Color get track =>
      _isLight ? const Color(0xFFE7EEFF) : const Color(0x24FFFFFF);

  static Color get primary =>
      _isLight ? const Color(0xFF3048CE) : const Color(0xFF6C8CFF);
  static Color get primaryContainer =>
      _isLight ? const Color(0xFF4C63E8) : const Color(0xFF4C63E8);
  static Color get primaryFixed =>
      _isLight ? const Color(0xFFDEE0FF) : const Color(0xFF24346E);
  static Color get onPrimaryFixed =>
      _isLight ? const Color(0xFF000F5D) : const Color(0xFFDEE0FF);
  static Color get onPrimary =>
      _isLight ? Colors.white : const Color(0xFF0A1433);

  static Color get indigo =>
      _isLight ? const Color(0xFF394FC7) : const Color(0xFF4353C9);
  static Color get mint =>
      _isLight ? const Color(0xFF006C4E) : const Color(0xFF63DCAD);
  static Color get secondary => mint;
  static Color get secondaryContainer =>
      _isLight ? const Color(0xFF81F9C8) : const Color(0xFF0B3D2D);
  static Color get onSecondaryContainer =>
      _isLight ? const Color(0xFF007353) : const Color(0xFF81F9C8);

  static Color get amber =>
      _isLight ? const Color(0xFFB26A00) : const Color(0xFFFFC45C);
  static Color get tertiary =>
      _isLight ? const Color(0xFF7D4E00) : const Color(0xFFFFC45C);
  static Color get tertiaryContainer =>
      _isLight ? const Color(0xFF9E6400) : const Color(0xFF7D4E00);
  static Color get tertiaryFixed =>
      _isLight ? const Color(0xFFFFDDB8) : const Color(0xFF3D2A0B);
  static Color get onTertiaryFixed =>
      _isLight ? const Color(0xFF2A1700) : const Color(0xFFFFDDB8);

  static Color get rose =>
      _isLight ? const Color(0xFFBA1A1A) : const Color(0xFFFFB4AB);
  static Color get error => rose;
  static Color get errorContainer =>
      _isLight ? const Color(0xFFFFDAD6) : const Color(0xFF4A1516);
  static Color get onErrorContainer =>
      _isLight ? const Color(0xFF93000A) : const Color(0xFFFFDAD6);

  static Color get cyan =>
      _isLight ? const Color(0xFF0E7490) : const Color(0xFF54C9E8);

  static Color get panelStart =>
      _isLight ? const Color(0xFFE9EEFB) : const Color(0xFF1B2740);
  static Color get panelEnd =>
      _isLight ? const Color(0xFFDCE4F7) : const Color(0xFF111823);

  /// Teks di atas panel brand yang selalu gelap (hero gradient).
  static const Color onHero = Color(0xFFF7F9FF);
  static const Color onHeroMuted = Color(0xFFC9D4EE);

  static const Color heroStart = Color(0xFF3048CE);
  static const Color heroEnd = Color(0xFF4C63E8);
}

ThemeData buildAppTheme() => _buildTheme(false);

ThemeData buildLightTheme() => _buildTheme(true);

TextStyle _style(
  double size,
  FontWeight weight, {
  double height = 1.4,
  double spacing = 0,
  Color? color,
}) => TextStyle(
  fontFamily: 'PlusJakartaSans',
  fontSize: size,
  fontWeight: weight,
  height: height,
  letterSpacing: spacing,
  color: color,
);

ThemeData _buildTheme(bool light) {
  final bg = light ? const Color(0xFFF9F9FF) : const Color(0xFF080C12);
  final surface = light ? const Color(0xFFFFFFFF) : const Color(0xFF111823);
  final surfaceAlt = light ? const Color(0xFFE7EEFF) : const Color(0xFF1A2433);
  final text = light ? const Color(0xFF111C2D) : const Color(0xFFF3F6FB);
  final muted = light ? const Color(0xFF444654) : const Color(0xFF9AA9BE);
  final line = light ? const Color(0x14000000) : const Color(0x14FFFFFF);
  final primary = light ? const Color(0xFF3048CE) : const Color(0xFF6C8CFF);
  final onPrimary = light ? Colors.white : const Color(0xFF0A1433);
  final mint = light ? const Color(0xFF006C4E) : const Color(0xFF63DCAD);
  final rose = light ? const Color(0xFFBA1A1A) : const Color(0xFFFFB4AB);

  final scheme = light
      ? ColorScheme.light(
          primary: primary,
          onPrimary: onPrimary,
          secondary: mint,
          onSecondary: Colors.white,
          surface: surface,
          onSurface: text,
          error: rose,
          onError: Colors.white,
          outline: muted,
        )
      : ColorScheme.dark(
          primary: primary,
          onPrimary: onPrimary,
          secondary: mint,
          onSecondary: const Color(0xFF032E23),
          surface: surface,
          onSurface: text,
          error: rose,
          onError: const Color(0xFF690005),
          outline: muted,
        );

  final base = ThemeData(
    useMaterial3: true,
    brightness: light ? Brightness.light : Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    fontFamily: 'PlusJakartaSans',
    splashFactory: InkSparkle.splashFactory,
  );

  return base.copyWith(
    textTheme: TextTheme(
      displayLarge: _style(
        44,
        FontWeight.w700,
        height: 1.25,
        spacing: -0.9,
        color: text,
      ),
      displayMedium: _style(
        36,
        FontWeight.w700,
        height: 1.25,
        spacing: -0.6,
        color: text,
      ),
      displaySmall: _style(
        30,
        FontWeight.w700,
        height: 1.2,
        spacing: -0.5,
        color: text,
      ),
      headlineLarge: _style(
        30,
        FontWeight.w700,
        height: 1.2,
        spacing: -0.5,
        color: text,
      ),
      headlineMedium: _style(
        24,
        FontWeight.w700,
        height: 1.25,
        spacing: -0.3,
        color: text,
      ),
      headlineSmall: _style(18, FontWeight.w600, height: 1.35, color: text),
      titleLarge: _style(
        20,
        FontWeight.w700,
        height: 1.35,
        spacing: -0.2,
        color: text,
      ),
      titleMedium: _style(15, FontWeight.w600, height: 1.4, color: text),
      titleSmall: _style(13, FontWeight.w600, height: 1.4, color: text),
      bodyLarge: _style(16, FontWeight.w400, height: 1.55, color: text),
      bodyMedium: _style(14, FontWeight.w400, height: 1.5, color: muted),
      bodySmall: _style(13, FontWeight.w400, height: 1.45, color: muted),
      labelLarge: _style(13, FontWeight.w600, height: 1.35, color: text),
      labelMedium: _style(12, FontWeight.w600, height: 1.35, color: text),
      labelSmall: _style(
        11,
        FontWeight.w500,
        height: 1.35,
        spacing: 0.3,
        color: muted,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: _style(18, FontWeight.w700, color: text),
      iconTheme: IconThemeData(color: text),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: DividerThemeData(color: line, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: TextStyle(color: muted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primary),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceAlt,
      selectedColor: primary.withValues(alpha: light ? 0.14 : 0.22),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: text,
      ),
      side: BorderSide(color: line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: light ? const Color(0xFF1F2937) : surfaceAlt,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        minimumSize: const Size(0, 48),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: text,
        side: BorderSide(color: line),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: primary.withValues(alpha: light ? 0.12 : 0.18),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected) ? primary : muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 23,
          color: states.contains(WidgetState.selected) ? primary : muted,
        ),
      ),
      elevation: 0,
      height: 70,
    ),
  );
}

Color levelColor(String level) {
  switch (level) {
    case 'A0':
      return AppColors.rose;
    case 'A1':
      return AppColors.primary;
    case 'A2':
      return AppColors.cyan;
    case 'B1':
      return AppColors.mint;
    case 'B2':
      return AppColors.amber;
    case 'C1':
      return AppColors.isLight
          ? const Color(0xFFC05621)
          : const Color(0xFFFF9F6B);
    default:
      return AppColors.rose;
  }
}

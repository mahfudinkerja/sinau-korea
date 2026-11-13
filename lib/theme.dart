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
      _isLight ? const Color(0xFFF5F7FC) : const Color(0xFF080C12);
  static Color get surface =>
      _isLight ? const Color(0xFFFFFFFF) : const Color(0xFF111823);
  static Color get surfaceAlt =>
      _isLight ? const Color(0xFFEDF1F8) : const Color(0xFF1A2433);
  static Color get text =>
      _isLight ? const Color(0xFF121826) : const Color(0xFFF3F6FB);
  static Color get muted =>
      _isLight ? const Color(0xFF5D6B80) : const Color(0xFF93A3B8);
  static Color get line =>
      _isLight ? const Color(0x14000000) : const Color(0x14FFFFFF);
  static Color get track =>
      _isLight ? const Color(0x1F000000) : const Color(0x24FFFFFF);

  static Color get primary =>
      _isLight ? const Color(0xFF4C63E8) : const Color(0xFF6C8CFF);
  static Color get indigo =>
      _isLight ? const Color(0xFF3B4BC2) : const Color(0xFF4353C9);
  static Color get mint =>
      _isLight ? const Color(0xFF0E9F75) : const Color(0xFF37D8A4);
  static Color get amber =>
      _isLight ? const Color(0xFFB7791F) : const Color(0xFFFFC45C);
  static Color get rose =>
      _isLight ? const Color(0xFFD64560) : const Color(0xFFFF7A90);
  static Color get cyan =>
      _isLight ? const Color(0xFF0E7490) : const Color(0xFF54C9E8);

  static Color get panelStart =>
      _isLight ? const Color(0xFFE9EEFB) : const Color(0xFF1B2740);
  static Color get panelEnd =>
      _isLight ? const Color(0xFFDCE4F7) : const Color(0xFF111823);

  /// Teks di atas panel brand yang selalu gelap (hero gradient).
  static const Color onHero = Color(0xFFF7F9FF);
  static const Color onHeroMuted = Color(0xFFC9D4EE);
}

ThemeData buildAppTheme() => _buildTheme(false);

ThemeData buildLightTheme() => _buildTheme(true);

ThemeData _buildTheme(bool light) {
  final bg = light ? const Color(0xFFF5F7FC) : const Color(0xFF080C12);
  final surface = light ? const Color(0xFFFFFFFF) : const Color(0xFF111823);
  final surfaceAlt =
      light ? const Color(0xFFEDF1F8) : const Color(0xFF1A2433);
  final text = light ? const Color(0xFF121826) : const Color(0xFFF3F6FB);
  final muted = light ? const Color(0xFF5D6B80) : const Color(0xFF93A3B8);
  final line = light ? const Color(0x14000000) : const Color(0x14FFFFFF);
  final primary =
      light ? const Color(0xFF4C63E8) : const Color(0xFF6C8CFF);
  final mint = light ? const Color(0xFF0E9F75) : const Color(0xFF37D8A4);
  final rose = light ? const Color(0xFFD64560) : const Color(0xFFFF7A90);

  final scheme = light
      ? ColorScheme.light(
          primary: primary,
          onPrimary: Colors.white,
          secondary: mint,
          onSecondary: Colors.white,
          surface: surface,
          onSurface: text,
          error: rose,
          outline: muted,
        )
      : ColorScheme.dark(
          primary: primary,
          onPrimary: Colors.white,
          secondary: mint,
          onSecondary: const Color(0xFF032E23),
          surface: surface,
          onSurface: text,
          error: rose,
          outline: muted,
        );

  final base = ThemeData(
    useMaterial3: true,
    brightness: light ? Brightness.light : Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    splashFactory: InkSparkle.splashFactory,
  );

  return base.copyWith(
    textTheme: base.textTheme
        .apply(bodyColor: text, displayColor: text)
        .copyWith(
          // Warna eksplisit wajib: TextStyle baru di copyWith tidak mewarisi
          // warna dari textTheme.apply dan bisa jatuh ke warna default gelap
          // (putih) saat mode terang.
          headlineLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            height: 1.15,
            color: text,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: text,
          ),
          titleLarge: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            color: text,
          ),
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: text,
          ),
          bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: muted),
          bodySmall: TextStyle(fontSize: 12, height: 1.45, color: muted),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: muted,
          ),
        ),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: text,
      ),
      iconTheme: IconThemeData(color: text),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: DividerThemeData(color: line, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: TextStyle(color: muted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: light ? const Color(0xFF1F2937) : surfaceAlt,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 52),
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: text,
        side: BorderSide(color: line),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: primary.withValues(alpha: light ? 0.13 : 0.18),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected) ? text : muted,
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

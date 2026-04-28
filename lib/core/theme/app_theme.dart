// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Palette ────────────────────────────────────────────────────
  static const Color bg           = Color(0xFF0A0C10);
  static const Color surface      = Color(0xFF13161C);
  static const Color surfaceAlt   = Color(0xFF1C2030);
  static const Color accent       = Color(0xFFE53935);   // Racing red
  static const Color accentGold   = Color(0xFFFFAB00);
  static const Color accentCyan   = Color(0xFF00E5FF);
  static const Color textPrimary  = Color(0xFFF5F5F5);
  static const Color textSecond   = Color(0xFF9E9E9E);
  static const Color divider      = Color(0xFF2A2D38);
  static const Color success      = Color(0xFF00E676);
  static const Color danger       = Color(0xFFFF1744);
  static const Color nitro        = Color(0xFF00B0FF);

  // ── Gradients ──────────────────────────────────────────────────
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0C10), Color(0xFF0F1520)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFAB00), Color(0xFFFF6F00)],
  );

  static const LinearGradient nitroGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF0091EA)],
  );

  // ── Typography ─────────────────────────────────────────────────
  static TextStyle get headingXL => GoogleFonts.rajdhani(
    fontSize: 42, fontWeight: FontWeight.w700,
    color: textPrimary, letterSpacing: 2,
  );

  static TextStyle get headingL => GoogleFonts.rajdhani(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: textPrimary, letterSpacing: 1.5,
  );

  static TextStyle get headingM => GoogleFonts.rajdhani(
    fontSize: 22, fontWeight: FontWeight.w600,
    color: textPrimary, letterSpacing: 1,
  );

  static TextStyle get labelS => GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w600,
    color: textSecond, letterSpacing: 2,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400, color: textSecond,
  );

  static TextStyle get bodyBold => GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary,
  );

  static TextStyle get speedometer => GoogleFonts.rajdhani(
    fontSize: 52, fontWeight: FontWeight.w700,
    color: textPrimary, letterSpacing: 2,
  );

  // ── ThemeData ──────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: accentGold,
      surface: surface,
      error: danger,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: headingM,
      iconTheme: const IconThemeData(color: textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: textPrimary,
        textStyle: GoogleFonts.rajdhani(
          fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
      ),
    ),
    cardTheme: CardTheme(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: divider, width: 1),
      ),
    ),
    dividerColor: divider,
    iconTheme: const IconThemeData(color: textSecond),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceAlt,
      contentTextStyle: body.copyWith(color: textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

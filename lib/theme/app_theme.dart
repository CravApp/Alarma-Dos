import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta oficial extraída pixel a pixel del documento ZIP original
class AppColors {
  // ── PÚRPURA PRINCIPAL ──────────────────────────────────────────
  // Aparece en: fondo login, botones primarios, cards planes, header home
  static const Color primaryPurple  = Color(0xFF782D69); // #782D69 — color dominante
  static const Color darkPurple     = Color(0xFF692D5A); // #692D5A — sombra/dark
  static const Color medPurple      = Color(0xFF783C69); // #783C69 — variante media
  static const Color lightPurple    = Color(0xFF874B78); // #874B78 — lila suave

  // ── ROSA HOT (lockscreen bg, card Visión, pin ubicación) ────────
  static const Color pinkHot        = Color(0xFFE178A5); // #E178A5 — rosa hot vibrante
  static const Color pinkVibrant    = Color(0xFFD25A96); // #D25A96 — rosa pin/iconos
  static const Color pinkMedium     = Color(0xFFD278A5); // #D278A5 — rosa intermedio

  // ── ROSA MILLENNIAL (input fields, acentos suaves) ─────────────
  static const Color pinkField      = Color(0xFFF0B4D2); // #F0B4D2 — campos input login
  static const Color pinkFieldLight = Color(0xFFF0C3D2); // #F0C3D2 — rosa muy claro
  static const Color pinkSoft       = Color(0xFFF0D2E1); // #F0D2E1 — card misión / lockscreen
  static const Color pinkPale       = Color(0xFFE1C3D2); // #E1C3D2 — fondo bluetooth
  static const Color pinkGreyish    = Color(0xFFE1D2D2); // #E1D2D2 — grisáceo permisos

  // ── FONDOS NEUTROS ──────────────────────────────────────────────
  static const Color bgLight        = Color(0xFFE1E1E1); // #E1E1E1 — gris claro permisos
  static const Color bgNearWhite    = Color(0xFFF0F0F0); // #F0F0F0 — casi blanco
  static const Color white          = Color(0xFFFFFFFF);

  // ── DORADO (gancho del charm) ───────────────────────────────────
  static const Color gold           = Color(0xFFC4A044); // #C4A044 — dorado gancho

  // ── TEXTO ───────────────────────────────────────────────────────
  static const Color textDark       = Color(0xFF1A1A1A);
  static const Color textGrey       = Color(0xFF6B6B6B);
  static const Color textPurple     = Color(0xFF782D69); // texto púrpura (títulos sobre blanco)

  // ── SEMÁNTICOS ──────────────────────────────────────────────────
  static const Color success        = Color(0xFF2D9B6B);
  static const Color danger         = Color(0xFFD9534F);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        primary: AppColors.primaryPurple,
        secondary: AppColors.pinkHot,
        surface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
        bodyLarge:   GoogleFonts.lato(fontSize: 16, color: AppColors.textDark),
        bodyMedium:  GoogleFonts.lato(fontSize: 14, color: AppColors.textGrey),
        bodySmall:   GoogleFonts.lato(fontSize: 12, color: AppColors.textGrey),
        labelLarge:  GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          elevation: 4,
          shadowColor: AppColors.darkPurple.withValues(alpha: 0.4),
          textStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          side: const BorderSide(color: AppColors.textDark, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          textStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.pinkField,       // #F0B4D2 — exacto del diseño
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
        ),
        hintStyle: GoogleFonts.lato(color: AppColors.textGrey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: AppColors.white,
      ),
    );
  }
}

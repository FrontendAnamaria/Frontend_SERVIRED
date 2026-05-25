import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilos tipográficos extraídos de Figma (nodo 150:3634)
/// Familias: Poppins · Inter · Source Sans Pro · Nunito
class AppTextStyles {
  AppTextStyles._();

  // ── Inter ──────────────────────────────────────────────────────────────────

  /// Regular Body L — Inter Regular 16/24
  static TextStyle get bodyL => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.textPrimary,
      );

  /// Bold Body L — Inter Bold 16/24
  static TextStyle get bodyLBold => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 24 / 16,
        color: AppColors.textPrimary,
      );

  /// Light Body M — Inter Light 12/18
  static TextStyle get bodyMLight => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        height: 18 / 12,
        color: AppColors.textSecondary,
      );

  /// H3 Light — Inter Light 22/28
  static TextStyle get h3Light => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        height: 28 / 22,
        color: AppColors.textPrimary,
      );

  /// H3 Bold — Inter Bold 22/28
  static TextStyle get h3Bold => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 28 / 22,
        color: AppColors.textPrimary,
      );

  // ── Poppins ────────────────────────────────────────────────────────────────

  /// Semibold Body L — Poppins SemiBold 14/24 (labels de formulario)
  static TextStyle get labelSemibold => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 24 / 14,
        color: AppColors.textPrimary,
      );

  /// Bold Body M — Poppins Bold 12 (tags, badges)
  static TextStyle get bodyMBold => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // ── Source Sans Pro ────────────────────────────────────────────────────────

  /// Paragraph Small / Heavy — Source Sans Pro SemiBold 13/20 (error messages)
  static TextStyle get errorText => GoogleFonts.sourceSans3(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 20 / 13,
        color: AppColors.error,
      );

  // ── Nunito ─────────────────────────────────────────────────────────────────

  /// Button — Nunito Bold 14 (texto del botón primario)
  static TextStyle get button => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.2,
      );

  // ── Derivados UI ───────────────────────────────────────────────────────────

  static TextStyle get inputHint => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.neutral5,
      );

  static TextStyle get inputText => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get formLabel => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get linkSecondary => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get linkGold => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.accent500,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.accent500,
      );
}

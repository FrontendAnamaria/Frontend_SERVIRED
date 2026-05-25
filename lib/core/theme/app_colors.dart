import 'package:flutter/material.dart';

/// Tokens de color extraídos directamente de Figma
/// Archivo: plataforma-Gane-Web · Nodo: 150:3634
class AppColors {
  AppColors._();

  // ── Marca ──────────────────────────────────────────────────────────────────
  /// Primary 700 — azul marino profundo (header, nav)
  static const Color primary700 = Color(0xFF2C2E6F);

  /// Secondary 500 — azul acción (botón activo, checkbox)
  static const Color secondary500 = Color(0xFF1372AE);

  /// Secondary 300 — azul claro (hover, bordes focus)
  static const Color secondary300 = Color(0xFF3C9BD6);

  /// Accent 500 — dorado GANE (logo, links, CTA secundarios)
  static const Color accent500 = Color(0xFFC7B322);

  // ── Neutros ────────────────────────────────────────────────────────────────
  static const Color neutralBlack = Color(0xFF09101D);   // Neutral/Black — fondo página
  static const Color neutralWhite = Color(0xFFFFFFFF);   // Neutral/White
  static const Color neutral5     = Color(0xFF858C94);   // placeholder text
  static const Color neutral3     = Color(0xFF545D69);   // texto secundario
  static const Color grey50       = Color(0xFFFAFAFA);   // fondo inputs
  static const Color grey600      = Color(0xFF4B5563);
  static const Color grey900      = Color(0xFF111827);

  // ── Texto ──────────────────────────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFF131927);   // Text Color/text-primary-black
  static const Color textSecondary = neutral3;
  static const Color textDisabled  = neutral5;
  static const Color textOnPrimary = neutralWhite;
  static const Color textGold      = accent500;          // "regístrate aquí"

  // ── Semánticos ─────────────────────────────────────────────────────────────
  static const Color error   = Color(0xFFDA1414);        // Status/Error
  static const Color errorBg = Color(0xFFFEEFEF);        // Status/Error BG

  // ── UI ─────────────────────────────────────────────────────────────────────
  static const Color pageBackground  = neutralBlack;     // fondo detrás del modal
  static const Color modalBackground = neutralWhite;
  static const Color inputBorder     = Color(0xFFD1D5DB);
  static const Color inputBorderFocus = secondary300;
  static const Color inputBorderError = error;
  static const Color inputFill        = neutralWhite;

  /// Botón deshabilitado — azul muy claro cuando el form está vacío
  static const Color buttonDisabled     = Color(0xFFBDD7EE);
  static const Color buttonDisabledText = Color(0xFF6B99B9);

  // ── Aliases de compatibilidad (widgets compartidos) ───────────────────────
  static const Color primary      = secondary500;
  static const Color background   = pageBackground;
  static const Color surface      = neutralWhite;
  static const Color success      = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color info         = secondary300;
  static const Color infoLight    = Color(0xFFE1F5FE);
  static const Color errorLight   = errorBg;
  static const Color border       = inputBorder;
  static const Color borderFocused = inputBorderFocus;
  static const Color divider      = Color(0xFFE2E8F0);
  static const Color cardBackground = neutralWhite;

  // ── Sombras ────────────────────────────────────────────────────────────────
  /// Sombra 200 — doble drop shadow (modal card)
  static List<BoxShadow> get sombra200 => [
        BoxShadow(
          color: const Color(0xFF131927).withOpacity(0.08),
          offset: const Offset(0, 8),
          blurRadius: 8,
          spreadRadius: -4,
        ),
        BoxShadow(
          color: const Color(0xFF131927).withOpacity(0.12),
          offset: const Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -4,
        ),
      ];
}

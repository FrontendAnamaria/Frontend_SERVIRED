import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

// ── Figma node 561:8147 — Header ─────────────────────────────────────────────
// Medidas exactas del nodo: 1728×104px
//
// Estructura principal:
//   backdrop-blur-[25px]  bg-[rgba(53,113,150,0.5)]
//   flex gap-[27px] items-center px-[21px]
//
//   ┌────────────────────────────────────────────────────────────────────────┐
//   │ Logo 150×66   │──27──│  Nav (Expanded, centrado) │──27──│  Botones    │
//   └────────────────────────────────────────────────────────────────────────┘
//
// Logo (I561:8147;720:2467):
//   w-[150px] h-[66px] — SVG asset AppAssets.logoGane
//
// Nav container (I561:8147;12:165):
//   w-[1031px] h-[85px] gap-[64px] items-center justify-center
//   Cada item (I561:8147;14:942): h-[69px] p-[10px] items-end
//     Texto: Inter Medium 34px · "Inicio" #feca0c · "Juegos/Resultados" #fafafa
//
// Botones container (I561:8147;17:1763):
//   w-[465px] h-[65px] gap-[16px] items-end justify-center
//   "Inicia sesión" (I561:8147;17:2083): h-41 w-184 rounded-14 bg-#fafafa
//     Texto: Inter SemiBold 14px · color #1372ae
//   "Regístrate" (I561:8147;17:1765): h-41 w-184 rounded-14 bg-#fdc700
//     Texto: Inter SemiBold 14px · color #093048

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key, this.onLoginTap});

  final VoidCallback? onLoginTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) return const _NavbarMobile();
        return _NavbarDesktop(onLoginTap: onLoginTap);
      },
    );
  }
}

// ── Desktop ───────────────────────────────────────────────────────────────────

class _NavbarDesktop extends StatelessWidget {
  const _NavbarDesktop({this.onLoginTap});

  final VoidCallback? onLoginTap;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          height: 104,
          width: double.infinity,
          color: AppColors.navbarBg, // rgba(53,113,150,0.5)
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Row(
            // items-center: todo centrado verticalmente en el header
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Logo 150×66 (Figma: w-[150px] h-[66px]) ──────────────
              SvgPicture.asset(
                AppAssets.logoGane,
                width: 150,
                height: 66,
                fit: BoxFit.contain,
              ),

              // gap-[27px] Figma entre logo y nav
              const SizedBox(width: 27),

              // ── Nav (Figma: w-[1031px] justify-center gap-[64px]) ─────
              // Expanded + FittedBox: en desktop (1728px) sin escala;
              // en pantallas más estrechas (tests, tablet) escala
              // proporcionalmente sin lanzar overflow exception.
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      _NavItem(label: 'Inicio', isActive: true),
                      SizedBox(width: 64),
                      _NavItem(label: 'Juegos'),
                      SizedBox(width: 64),
                      _NavItem(label: 'Resultados'),
                    ],
                  ),
                ),
              ),

              // gap-[27px] Figma entre nav y botones
              const SizedBox(width: 27),

              // ── Botones (Figma: h-[65px] items-end gap-[16px]) ────────
              // items-end: botones alineados al fondo del contenedor 65px.
              // En el Row externo con CrossAxisAlignment.center, el
              // SizedBox(h-65) queda centrado en el header (104px).
              // Los botones (h-41) dentro se alinean al bottom del SizedBox.
              SizedBox(
                height: 65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        _NavWhiteButton(label: 'Inicia sesión', onTap: onLoginTap),
                        const SizedBox(width: 16),
                        const _NavYellowButton(label: 'Regístrate'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Mobile ────────────────────────────────────────────────────────────────────

class _NavbarMobile extends StatelessWidget {
  const _NavbarMobile();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          height: 64,
          width: double.infinity,
          color: AppColors.navbarBg,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.logoGane,
                height: 36,
                fit: BoxFit.fitHeight,
              ),
              const Spacer(),
              const Icon(
                Icons.menu_rounded,
                color: AppColors.neutralWhite,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Nav item ──────────────────────────────────────────────────────────────────
// Figma (I561:8147;14:942):
//   h-[69px] · p-[10px] · items-end · justify-center
//   Texto interior: h-[49px] justify-end → alineado al fondo del padding

class _NavItem extends StatelessWidget {
  const _NavItem({required this.label, this.isActive = false});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 69,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.bottomCenter,
        child: Text(
          label,
          style: AppTextStyles.navLink.copyWith(
            // Inicio → #feca0c (activo), demás → #fafafa
            color: isActive
                ? AppColors.navActiveYellow
                : const Color(0xFFFAFAFA),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ── Botón "Inicia sesión" ─────────────────────────────────────────────────────
// Figma: h-[41px] w-[184px] rounded-[14px] bg-[#fafafa]
// Texto: Inter SemiBold 14px · color: var(--secondary-500,#1372ae)

class _NavWhiteButton extends StatelessWidget {
  const _NavWhiteButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 41,
        width: 184,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.navButtonOutlined, // #1372ae sobre #fafafa
        ),
      ),
    );
  }
}

// ── Botón "Regístrate" ────────────────────────────────────────────────────────
// Figma: h-[41px] w-[184px] rounded-[14px] bg-[#fdc700]
// Texto: Inter SemiBold 14px · color: #093048

class _NavYellowButton extends StatelessWidget {
  const _NavYellowButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 41,
        width: 184,
        decoration: BoxDecoration(
          color: AppColors.navBtnYellow, // #fdc700
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.navButtonFilled, // #093048 sobre #fdc700
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../widgets/acumulados_section_widget.dart';
import '../widgets/banner_carousel_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/juegos_section_widget.dart';
import '../widgets/navbar_widget.dart';
import '../widgets/resultados_carousel_widget.dart';
import '../widgets/section_header_widget.dart';

void _showLoginModal(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SingleChildScrollView(
        child: LoginFormWidget(
          onClose: () => Navigator.pop(dialogContext),
          onLoginSuccess: () => Navigator.pop(dialogContext),
        ),
      ),
    ),
  );
}

// Figma node 561:8092 — Landing page
// bg-[var(--secondary-500,#1372ae)]
// Navbar: sticky overlay (Stack), altura 104px reservada con SizedBox

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Altura exacta del header según Figma (561:8147): 104px
  static const double _navbarHeight = 104;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Único proveedor de fondo — #1372AE continuo para toda la página.
      // Ninguna sección intermedia debe declarar su propio color.
      backgroundColor: AppColors.homeBackground,
      body: Stack(
        children: [
          // ── Contenido scrollable ───────────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Espacio reservado para el navbar fijo
                const SizedBox(height: _navbarHeight),

                // ── Contenido principal — max-width 1728, centrado ─────────
                // Figma 561:8094: flex-col gap-[16px] px-[20px] py-[32px]
                // Sin gradiente propio; hereda homeBackground del Scaffold.
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1728),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Banner carousel ────────────────────────────────
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: BannerCarouselWidget(),
                        ),

                        // ── Acumulados ─────────────────────────────────────
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: AcumuladosSectionWidget(),
                        ),

                        // ── Resultados loterías y sorteos ──────────────────
                        const SizedBox(height: 16),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: SectionHeaderWidget(
                            icon: SvgPicture.asset(
                              AppAssets.iconResultados,
                              width: 28,
                              height: 28,
                            ),
                            title: 'Resultados loterías y sorteos',
                            showVerMas: true,
                            onVerMas: () {},
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: ResultadosCarouselWidget(),
                        ),

                        // ── Juegos ─────────────────────────────────────────
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: JuegosSectionWidget(),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Gap entre tarjetas y footer ────────────────────────────
                // Figma: row 2 termina y:1973, footer border-top en y:1989 → 16px
                const SizedBox(height: 16),

                // ── Footer — full-width ────────────────────────────────────
                const FooterWidget(),
              ],
            ),
          ),

          // ── Navbar fija/sticky — overlay sobre el scroll ──────────────────
          // Figma: h-104, backdrop-blur-25, bg rgba(53,113,150,0.5)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavbarWidget(
              onLoginTap: () => _showLoginModal(context),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import 'juego_card_widget.dart';
import 'section_header_widget.dart';

// Figma nodes 561:8133 y 561:8139
// 2 filas de 5 tarjetas (288×360px), gap ~58px entre tarjetas
// Cada tarjeta usa una imagen distinta de AppAssets.juegoImages

const _kJuegos = [
  JuegoData(
    imageUrl: AppAssets.juegoGenerico,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
  JuegoData(
    imageUrl: AppAssets.juegoImg2,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
  JuegoData(
    imageUrl: AppAssets.juegoImg3,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
  JuegoData(
    imageUrl: AppAssets.juegoImg4,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
  JuegoData(
    imageUrl: AppAssets.juegoImg5,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
  JuegoData(
    imageUrl: AppAssets.juegoImg6,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
  JuegoData(
    imageUrl: AppAssets.juegoImg7,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
  JuegoData(
    imageUrl: AppAssets.juegoImg8,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
  JuegoData(
    imageUrl: AppAssets.juegoImg9,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
  JuegoData(
    imageUrl: AppAssets.juegoImg10,
    label: 'Apostá desde 2.000 y ganá hasta',
    monto: '\$118.278.000',
  ),
];

class JuegosSectionWidget extends StatelessWidget {
  const JuegosSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final row1 = _kJuegos.sublist(0, 5);
    final row2 = _kJuegos.sublist(5, 10);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header "Juegos" ─────────────────────────────────────────────────
        SectionHeaderWidget(
          icon: const Icon(
            Icons.sports_esports_rounded,
            size: 28,
            color: AppColors.neutralWhite,
          ),
          title: 'Juegos',
          showVerMas: true,
          onVerMas: () {},
        ),
        const SizedBox(height: 16),

        // ── Fila 1 ──────────────────────────────────────────────────────────
        _JuegosRow(juegos: row1),
        const SizedBox(height: 16),

        // ── Fila 2 ──────────────────────────────────────────────────────────
        _JuegosRow(juegos: row2),
      ],
    );
  }
}

class _JuegosRow extends StatelessWidget {
  const _JuegosRow({required this.juegos});

  final List<JuegoData> juegos;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1500;
        if (isWide) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final j in juegos) JuegoCardWidget(data: j),
            ],
          );
        }
        // scroll horizontal en pantallas pequeñas
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < juegos.length; i++) ...[
                JuegoCardWidget(data: juegos[i]),
                if (i < juegos.length - 1) const SizedBox(width: 58),
              ],
            ],
          ),
        );
      },
    );
  }
}

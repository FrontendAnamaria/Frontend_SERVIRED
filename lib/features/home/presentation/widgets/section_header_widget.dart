import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

// Figma: header row h=36px, icono 28-32px, título Inter Bold 32/24, pill "Ver más"

class SectionHeaderWidget extends StatelessWidget {
  const SectionHeaderWidget({
    super.key,
    required this.icon,
    required this.title,
    this.showVerMas = false,
    this.onVerMas,
  });

  final Widget icon;
  final String title;
  final bool showVerMas;
  final VoidCallback? onVerMas;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Icono + Título ───────────────────────────────────────────────
          icon,
          const SizedBox(width: 8),
          Flexible(child: Text(title, style: AppTextStyles.sectionTitle)),

          // ── Pill "Ver más" (solo en Resultados y Juegos) ─────────────────
          if (showVerMas) ...[
            const Spacer(),
            GestureDetector(
              onTap: onVerMas,
              child: Container(
                // Figma: pl-16 pr-4 py-8, rounded-99px, bg rgba(255,255,255,0.16)
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 4,
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.seeMorePill,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ver más', style: AppTextStyles.verMasText),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.neutralWhite,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

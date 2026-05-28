import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

const _kBannerUrls = AppAssets.banners;

// Figma: cada banner 821×304px, gap 5px, carousel h=333px, botones 37×37px
const double _kBannerH      = 304.0;
const double _kCarouselH    = 333.0;
const double _kBannerRadius = 16.0;
const double _kGap          = 5.0;
// viewportFraction = (821+5) / 1688 para pantalla de referencia 1728px
const double _kVF           = 0.489;

class BannerCarouselWidget extends StatefulWidget {
  const BannerCarouselWidget({super.key});

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: _kVF);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _prev() => _controller.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );

  void _next() => _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    final vPad = (_kCarouselH - _kBannerH) / 2; // 14.5 px top/bottom

    return SizedBox(
      height: _kCarouselH,
      child: Stack(
        children: [
          // ── Carrusel ──────────────────────────────────────────────────────
          PageView.builder(
            controller: _controller,
            padEnds: false,
            itemCount: _kBannerUrls.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  right: _kGap,
                  top: vPad,
                  bottom: vPad,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_kBannerRadius),
                  child: Image.asset(
                    _kBannerUrls[i],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _BannerPlaceholder(index: i),
                  ),
                ),
              );
            },
          ),

          // ── Botón izquierda (x=11, centrado verticalmente) ────────────────
          Positioned(
            left: 11,
            top: 0,
            bottom: 0,
            child: Center(
              child: _NavButton(onTap: _prev, isForward: false),
            ),
          ),

          // ── Botón derecha ─────────────────────────────────────────────────
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _NavButton(onTap: _next, isForward: true),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Botón de navegación ────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  const _NavButton({required this.onTap, required this.isForward});

  final VoidCallback onTap;
  final bool isForward;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 37,
        height: 37,
        decoration: const BoxDecoration(
          color: Color(0xB3111827), // rgba(17,24,39,0.7)
          shape: BoxShape.circle,
        ),
        child: Icon(
          isForward ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
          color: AppColors.neutralWhite,
          size: 22,
        ),
      ),
    );
  }
}

// ── Placeholder cuando la imagen no carga ──────────────────────────────────

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder({required this.index});

  final int index;

  static const _colors = [
    Color(0xFF1E3A5F),
    Color(0xFF0B4F6C),
    Color(0xFF1A2744),
    Color(0xFF0D3349),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _colors[index % _colors.length],
        borderRadius: BorderRadius.circular(_kBannerRadius),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.white38, size: 64),
      ),
    );
  }
}

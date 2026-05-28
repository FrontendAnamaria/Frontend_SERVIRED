abstract final class AppAssets {
  // ── Logo Gane (SVG) ───────────────────────────────────────────────────────
  static const String logoGane = 'assets/images/logo_gane.svg';

  // ── Banners (carousel principal) ──────────────────────────────────────────
  static const String bannerAstro   = 'assets/images/banner_1.png';
  static const String bannerBaloto  = 'assets/images/banner_2.png';
  static const String bannerBanner3 = 'assets/images/banner_3.png';
  static const String bannerBanner4 = 'assets/images/banner_1.png'; // reusar

  static const List<String> banners = [
    bannerAstro,
    bannerBaloto,
    bannerBanner3,
    bannerBanner4,
  ];

  // ── Logos de loterías — acumulados ────────────────────────────────────────
  static const String logoDobleChance      = 'assets/images/logo_doble_chance.png';
  static const String logoBalotoRevancha   = 'assets/images/logo_baloto_revancha.png';
  static const String logoChanceMillonario = 'assets/images/logo_chance_millonario.png';
  static const String logoMiLoto           = 'assets/images/logo_mi_loto.png';
  static const String logoIColorLoto       = 'assets/images/logo_i_color_loto.png';

  // ── Íconos de secciones ───────────────────────────────────────────────────
  static const String iconResultados = 'assets/images/icon_resultados.svg';
  static const String iconAcumulados = 'assets/images/icon_acumulados.svg';
  static const String iconReloj      = 'assets/images/icon_reloj.svg';

  // ── Logos de loterías — resultados ────────────────────────────────────────
  static const String logoRisaralda = 'assets/images/logo_risaralda.png';
  static const String logoValle     = 'assets/images/logo_valle.png';

  // ── Juegos ────────────────────────────────────────────────────────────────
  // Archivos disponibles: juego_1..3, juego_5, juego_6, juego_8, juego_10
  // juego_4, juego_7, juego_9 no existen — se mapean a imágenes existentes
  static const String juegoGenerico = 'assets/images/juego_1.png';
  static const String juegoImg2     = 'assets/images/juego_2.png';
  static const String juegoImg3     = 'assets/images/juego_3.png';
  static const String juegoImg4     = 'assets/images/juego_5.png';  // juego_4 no existe
  static const String juegoImg5     = 'assets/images/juego_6.png';
  static const String juegoImg6     = 'assets/images/juego_8.png';
  static const String juegoImg7     = 'assets/images/juego_10.png';
  static const String juegoImg8     = 'assets/images/juego_1.png';  // juego_7 no existe
  static const String juegoImg9     = 'assets/images/juego_2.png';  // juego_9 no existe
  static const String juegoImg10    = 'assets/images/juego_3.png';

  static const List<String> juegoImages = [
    juegoGenerico, juegoImg2, juegoImg3, juegoImg4, juegoImg5,
    juegoImg6,     juegoImg7, juegoImg8, juegoImg9, juegoImg10,
  ];

  // ── Footer — logos regulatorios ───────────────────────────────────────────
  // Usar las imágenes de mayor resolución disponibles
  static const String logoVigilado  = 'assets/images/logo_vigilado_supersalud.png';
  static const String logoColjuegos = 'assets/images/coljuegos-logo-01.png';
}

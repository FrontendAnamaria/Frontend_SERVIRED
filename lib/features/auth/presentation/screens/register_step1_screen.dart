import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/input_error_box.dart';

// Figma: plataforma-Gane-Web · node 35:2629 "Registro paso 1"
// Canvas 1728px · Modal total: 1219×864px · bg #1372AE · radius 38px
// Panel izquierdo (banner): 639px · Panel derecho (form): 580px
// Input container: 466px · Button: 371×57px

class RegisterStep1Widget extends StatefulWidget {
  const RegisterStep1Widget({
    super.key,
    required this.onClose,
    required this.onLoginRequested,
  });

  final VoidCallback onClose;
  final VoidCallback onLoginRequested;

  @override
  State<RegisterStep1Widget> createState() => _RegisterStep1WidgetState();
}

class _RegisterStep1WidgetState extends State<RegisterStep1Widget> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool? _isAdult; // null = sin selección, true = SI, false = NO
  DateTime? _birthDate;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;

  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _confirmTouched = false;
  bool _birthDateTouched = false;

  bool get _canSubmit {
    if (_emailCtrl.text.trim().isEmpty ||
        Validators.email(_emailCtrl.text.trim()) != null) {
      return false;
    }
    if (_passwordCtrl.text.isEmpty ||
        Validators.password(_passwordCtrl.text) != null) {
      return false;
    }
    if (_confirmCtrl.text.isEmpty ||
        Validators.confirmPassword(_confirmCtrl.text, _passwordCtrl.text) !=
            null) {
      return false;
    }
    if (_isAdult != true) { return false; }
    if (_birthDate == null || Validators.birthDate(_birthDate) != null) {
      return false;
    }
    return _acceptTerms && _acceptPrivacy;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _birthDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year - 18, now.month, now.day);
    final initial = (_birthDate != null && !_birthDate!.isAfter(lastDate))
        ? _birthDate!
        : DateTime(now.year - 25, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: lastDate,
    );
    if (picked != null && mounted) {
      setState(() {
        _birthDate = picked;
        _birthDateCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
        _birthDateTouched = true;
      });
    }
  }

  void _onSubmit() {
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
      _confirmTouched = true;
      _birthDateTouched = true;
    });
    if (!_formKey.currentState!.validate()) return;
    if (_isAdult != true || _birthDate == null) return;
    if (!_acceptTerms || !_acceptPrivacy) return;
    // TODO: avanzar al paso 2 del registro
  }

  @override
  Widget build(BuildContext context) {
    return _RegisterStep1Card(
      formKey: _formKey,
      emailCtrl: _emailCtrl,
      passwordCtrl: _passwordCtrl,
      confirmCtrl: _confirmCtrl,
      birthDateCtrl: _birthDateCtrl,
      obscurePassword: _obscurePassword,
      obscureConfirm: _obscureConfirm,
      isAdult: _isAdult,
      acceptTerms: _acceptTerms,
      acceptPrivacy: _acceptPrivacy,
      emailTouched: _emailTouched,
      passwordTouched: _passwordTouched,
      confirmTouched: _confirmTouched,
      birthDateTouched: _birthDateTouched,
      canSubmit: _canSubmit,
      onTogglePassword: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      onToggleConfirm: () =>
          setState(() => _obscureConfirm = !_obscureConfirm),
      onEmailChanged: (_) => setState(() {}),
      onPasswordChanged: (_) => setState(() {}),
      onConfirmChanged: (_) => setState(() {}),
      onAdultChanged: (v) => setState(() => _isAdult = v),
      onPickDate: _pickDate,
      onTermsChanged: (v) => setState(() => _acceptTerms = v ?? false),
      onPrivacyChanged: (v) => setState(() => _acceptPrivacy = v ?? false),
      onSubmit: _onSubmit,
      onClose: widget.onClose,
      onLoginRequested: widget.onLoginRequested,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Card del modal — dos paneles: banner (izquierdo) + formulario (derecho)
// ──────────────────────────────────────────────────────────────────────────────

class _RegisterStep1Card extends StatelessWidget {
  const _RegisterStep1Card({
    required this.formKey,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.birthDateCtrl,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.isAdult,
    required this.acceptTerms,
    required this.acceptPrivacy,
    required this.emailTouched,
    required this.passwordTouched,
    required this.confirmTouched,
    required this.birthDateTouched,
    required this.canSubmit,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmChanged,
    required this.onAdultChanged,
    required this.onPickDate,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
    required this.onSubmit,
    required this.onClose,
    required this.onLoginRequested,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final TextEditingController birthDateCtrl;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool? isAdult;
  final bool acceptTerms;
  final bool acceptPrivacy;
  final bool emailTouched;
  final bool passwordTouched;
  final bool confirmTouched;
  final bool birthDateTouched;
  final bool canSubmit;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmChanged;
  final ValueChanged<bool?> onAdultChanged;
  final VoidCallback onPickDate;
  final ValueChanged<bool?> onTermsChanged;
  final ValueChanged<bool?> onPrivacyChanged;
  final VoidCallback onSubmit;
  final VoidCallback onClose;
  final VoidCallback onLoginRequested;

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    // Canvas 1728px, modal total 1219px (70.5%).
    final double modalW = (sw * (1219.0 / 1728.0)).clamp(380.0, 1219.0);
    final bool showBanner = modalW >= 700.0;
    // Banner ocupa 639/1219 ≈ 52.4% del modal total.
    final double bannerW = showBanner ? (639.0 / 1219.0) * modalW : 0.0;
    final double formPanelW = modalW - bannerW;
    // Escala relativa al panel del formulario en Figma (580px).
    final double scale = (formPanelW / 580.0).clamp(0.65, 1.0);

    final double inputW =
        (466.0 * scale).clamp(260.0, 466.0).clamp(0, formPanelW - 24);
    final double buttonW = (371.0 * scale).clamp(240.0, 371.0);
    final double logoW = (179.0 * scale).clamp(80.0, 179.0);
    final double logoH = (79.0 * scale).clamp(36.0, 79.0);

    return Container(
      width: modalW,
      decoration: BoxDecoration(
        color: AppColors.secondary500,
        borderRadius: BorderRadius.circular(38),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A131927),
            offset: Offset(0, 10),
            blurRadius: 32,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Color(0x1F131927),
            offset: Offset(0, 6),
            blurRadius: 14,
            spreadRadius: -6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Banner izquierdo ─────────────────────────────────────────
              if (showBanner)
                SizedBox(
                  width: bannerW,
                  child: Image.asset(
                    AppAssets.bannerRegistro,
                    fit: BoxFit.cover,
                  ),
                ),

              // ── Panel derecho: formulario ────────────────────────────────
              SizedBox(
                width: formPanelW,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Botón cerrar ────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: onClose,
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.cancel_outlined,
                                size: 24,
                                color: AppColors.neutralWhite,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ── Título: "Bienvenido a" + logo Gane ──────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bienvenido a ',
                              style: GoogleFonts.inter(
                                fontSize:
                                    (32.0 * scale).clamp(18.0, 32.0),
                                fontWeight: FontWeight.w600,
                                height: 38 / 32,
                                color: AppColors.neutralWhite,
                              ),
                            ),
                            SvgPicture.asset(
                              AppAssets.logoGane,
                              width: logoW,
                              height: logoH,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),

                      // ── Subtítulo ────────────────────────────────────────
                      SizedBox(
                        width: inputW,
                        child: Text(
                          'Crea tu cuenta y descubre un mundo donde cada jugada cuenta.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize:
                                (22.0 * scale).clamp(13.0, 22.0),
                            fontWeight: FontWeight.w300,
                            height: 28 / 22,
                            color: AppColors.neutralWhite,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Correo electrónico ───────────────────────────────
                      SizedBox(
                        width: inputW,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _RegLabel(
                                text: 'Correo electronico',
                                scale: scale,),
                            const SizedBox(height: 1),
                            _RegInput(
                              controller: emailCtrl,
                              hint: 'ejemplo@correo.com',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: onEmailChanged,
                              validator:
                                  emailTouched ? Validators.email : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Contraseña ───────────────────────────────────────
                      SizedBox(
                        width: inputW,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _RegLabel(
                                text: 'Contraseña', scale: scale,),
                            const SizedBox(height: 1),
                            _RegPasswordInput(
                              controller: passwordCtrl,
                              obscure: obscurePassword,
                              onToggle: onTogglePassword,
                              onChanged: onPasswordChanged,
                              validator: passwordTouched
                                  ? Validators.password
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Confirmar contraseña ─────────────────────────────
                      SizedBox(
                        width: inputW,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _RegLabel(
                                text: 'Confirma tu contraseña',
                                scale: scale,),
                            const SizedBox(height: 1),
                            _RegPasswordInput(
                              controller: confirmCtrl,
                              obscure: obscureConfirm,
                              onToggle: onToggleConfirm,
                              onChanged: onConfirmChanged,
                              validator: confirmTouched
                                  ? (v) => Validators.confirmPassword(
                                        v,
                                        passwordCtrl.text,
                                      )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── ¿Eres mayor de edad? ─────────────────────────────
                      SizedBox(
                        width: inputW,
                        child: _AgeRadioRow(
                          isAdult: isAdult,
                          onChanged: onAdultChanged,
                          scale: scale,
                        ),
                      ),
                      // Error al seleccionar NO (HU: bloquear y avisar)
                      if (isAdult == false)
                        SizedBox(
                          width: inputW,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: InputErrorBox(
                              errorText:
                                  'Debes ser mayor de edad para registrarte.',
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),

                      // ── Fecha de nacimiento ──────────────────────────────
                      SizedBox(
                        width: inputW,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _RegLabel(
                                text: 'Fecha de nacimiento',
                                scale: scale,),
                            const SizedBox(height: 1),
                            _RegDateInput(
                              controller: birthDateCtrl,
                              onTap: onPickDate,
                              validator: birthDateTouched
                                  ? (v) => (v == null || v.isEmpty)
                                      ? 'La fecha de nacimiento es obligatoria.'
                                      : null
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Checkbox: términos y condiciones ─────────────────
                      SizedBox(
                        width: inputW,
                        child: _RegCheckbox(
                          value: acceptTerms,
                          onChanged: onTermsChanged,
                          scale: scale,
                          prefix: 'Acepto los ',
                          link: 'términos y condiciones',
                        ),
                      ),
                      const SizedBox(height: 4),

                      // ── Checkbox: política de tratamiento ────────────────
                      SizedBox(
                        width: inputW,
                        child: _RegCheckbox(
                          value: acceptPrivacy,
                          onChanged: onPrivacyChanged,
                          scale: scale,
                          prefix: 'Acepto la ',
                          link: 'política de tratamiento de mis datos',
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Botón Registrarme ────────────────────────────────
                      _RegSubmitButton(
                        onPressed: onSubmit,
                        canSubmit: canSubmit,
                        width: buttonW,
                        scale: scale,
                      ),
                      const SizedBox(height: 6),

                      // ── Link: ¡Ya tengo una cuenta! ──────────────────────
                      GestureDetector(
                        onTap: onLoginRequested,
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize:
                                  (14.0 * scale).clamp(10.0, 14.0),
                              fontWeight: FontWeight.w400,
                              color: AppColors.neutralWhite,
                            ),
                            children: const [
                              TextSpan(text: '¡Ya tengo una cuenta! '),
                              TextSpan(
                                text: 'Inicia sesión aquí',
                                style: TextStyle(color: Color(0xFFFFCC00)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ──────────────────────────────────────────────────────────────────────────────

// Label de campo con asterisco en Source Sans Pro
class _RegLabel extends StatelessWidget {
  const _RegLabel({required this.text, this.scale = 1.0});

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: GoogleFonts.poppins(
                fontSize: (14.0 * scale).clamp(9.0, 14.0),
                fontWeight: FontWeight.w600,
                height: 24 / 14,
                color: AppColors.neutralWhite.withValues(alpha: 0.8),
              ),
            ),
            TextSpan(
              text: '*',
              style: GoogleFonts.sourceSans3(
                fontSize: (13.0 * scale).clamp(9.0, 13.0),
                fontWeight: FontWeight.w600,
                height: 20 / 13,
                color: AppColors.neutralWhite.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Input de texto estándar
class _RegInput extends StatelessWidget {
  const _RegInput({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final String? errorText = validator?.call(controller.text);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralBlack,
          ),
          decoration: _regDeco(hint: hint, hasError: errorText != null),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 1),
          InputErrorBox(errorText: errorText),
        ],
      ],
    );
  }
}

// Input de contraseña con toggle de visibilidad
class _RegPasswordInput extends StatelessWidget {
  const _RegPasswordInput({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final String? errorText = validator?.call(controller.text);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralBlack,
          ),
          decoration:
              _regDeco(hint: '••••••••••••••••', hasError: errorText != null)
                  .copyWith(
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.neutral5,
                size: 20,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 1),
          InputErrorBox(errorText: errorText),
        ],
      ],
    );
  }
}

// Input de fecha (read-only, abre date picker al tocar)
class _RegDateInput extends StatelessWidget {
  const _RegDateInput({
    required this.controller,
    required this.onTap,
    this.validator,
  });

  final TextEditingController controller;
  final VoidCallback onTap;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final String? errorText = validator?.call(controller.text);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralBlack,
          ),
          decoration:
              _regDeco(hint: 'DD/MM/AAAA', hasError: errorText != null)
                  .copyWith(
            suffixIcon: GestureDetector(
              onTap: onTap,
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: AppColors.neutral5,
                ),
              ),
            ),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 1),
          InputErrorBox(errorText: errorText),
        ],
      ],
    );
  }
}

// Fila de radios: ¿Eres mayor de edad? SI / NO
class _AgeRadioRow extends StatelessWidget {
  const _AgeRadioRow({
    required this.isAdult,
    required this.onChanged,
    this.scale = 1.0,
  });

  final bool? isAdult;
  final ValueChanged<bool?> onChanged;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  // Dos espacios entre "Eres" y "mayor" — literal del Figma
                  text: '¿Eres  mayor de edad?',
                  style: GoogleFonts.poppins(
                    fontSize: (14.0 * scale).clamp(9.0, 14.0),
                    fontWeight: FontWeight.w600,
                    height: 24 / 14,
                    color: AppColors.neutralWhite.withValues(alpha: 0.8),
                  ),
                ),
                TextSpan(
                  text: '*',
                  style: GoogleFonts.sourceSans3(
                    fontSize: (13.0 * scale).clamp(9.0, 13.0),
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutralWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: (40.0 * scale).clamp(16.0, 40.0)),
          _AgeOption(
            label: 'SI',
            selected: isAdult == true,
            onTap: () => onChanged(true),
            scale: scale,
          ),
          SizedBox(width: (40.0 * scale).clamp(16.0, 40.0)),
          _AgeOption(
            label: 'NO',
            selected: isAdult == false,
            onTap: () => onChanged(false),
            scale: scale,
          ),
        ],
      ),
    );
  }
}

// Opción individual de radio (SI / NO)
class _AgeOption extends StatelessWidget {
  const _AgeOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.scale = 1.0,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double size = (24.0 * scale).clamp(18.0, 24.0);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: (14.0 * scale).clamp(9.0, 14.0),
              fontWeight: FontWeight.w600,
              height: 24 / 14,
              color: AppColors.neutralWhite.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  selected ? AppColors.neutralWhite : Colors.transparent,
              border: Border.all(
                color: AppColors.neutralWhite,
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: size * 0.42,
                      height: size * 0.42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary500,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

// Fila de checkbox con texto y fragmento subrayado como enlace
class _RegCheckbox extends StatelessWidget {
  const _RegCheckbox({
    required this.value,
    required this.onChanged,
    required this.prefix,
    required this.link,
    this.scale = 1.0,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String prefix;
  final String link;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primary700,
                checkColor: AppColors.neutralWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                side: const BorderSide(
                  color: AppColors.neutralWhite,
                  width: 1.5,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: (16.0 * scale).clamp(11.0, 16.0),
                    fontWeight: FontWeight.w400,
                    color: AppColors.neutralWhite,
                  ),
                  children: [
                    TextSpan(text: prefix),
                    TextSpan(
                      text: link,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.neutralWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Botón Registrarme: deshabilitado (#d7d7d7) / activo (secondary300)
class _RegSubmitButton extends StatelessWidget {
  const _RegSubmitButton({
    required this.onPressed,
    required this.canSubmit,
    required this.width,
    this.scale = 1.0,
  });

  final VoidCallback onPressed;
  final bool canSubmit;
  final double width;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: (57.0 * scale).clamp(44.0, 57.0),
      decoration: BoxDecoration(
        color: canSubmit
            ? AppColors.secondary300
            : const Color(0xFFD7D7D7),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canSubmit ? onPressed : null,
          borderRadius: BorderRadius.circular(26),
          child: Center(
            child: Text(
              'Registrarme',
              style: GoogleFonts.inter(
                fontSize: (20.0 * scale).clamp(14.0, 20.0),
                fontWeight: FontWeight.w600,
                color: AppColors.neutralWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Decoración común para inputs del modal de registro
// bg blanco (o #feefef en error), borde #858c94, rounded-30px, Inter Regular 16px
InputDecoration _regDeco({String? hint, bool hasError = false}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.neutralBlack.withValues(alpha: 0.5),
    ),
    filled: true,
    // Figma error state: bg #feefef cuando hay error, blanco en normal
    fillColor: hasError ? AppColors.errorBg : AppColors.neutralWhite,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: AppColors.neutral5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: hasError ? AppColors.inputBorderError : AppColors.neutral5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: hasError ? AppColors.inputBorderError : AppColors.inputBorderFocus,
        width: 1.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: AppColors.inputBorderError),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(
        color: AppColors.inputBorderError,
        width: 1.5,
      ),
    ),
    // El texto de error nativo se oculta — se muestra con InputErrorBox
    errorStyle: const TextStyle(height: 0, fontSize: 0.01),
    errorMaxLines: 1,
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
  );
}

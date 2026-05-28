import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/document_type.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/input_error_box.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'otp_verification_screen.dart';

// Figma: plataforma-Gane-Web · node 561:8743 "login"
// Canvas reference: 1728px · Modal: 704×881px · bg #1372AE · border-radius 38px
// Scaled proportionally to viewport: width = min(viewport × 0.407, 704)

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({
    super.key,
    required this.onClose,
    required this.onLoginSuccess,
    this.onRecoveryRequested,
    this.onRegisterRequested,
  });

  final VoidCallback onClose;
  final VoidCallback onLoginSuccess;
  /// Called with the identifier (doc number) when otpSent — parent closes
  /// the modal and navigates to OTP verification.
  final ValueChanged<String>? onRecoveryRequested;
  final VoidCallback? onRegisterRequested;

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _docNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  DocumentType? _selectedDocType;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _docNumberTouched = false;
  bool _passwordTouched = false;

  bool get _canSubmit =>
      _selectedDocType != null &&
      _docNumberController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  // ── Recover-password sub-form state ────────────────────────────────────────
  bool _showForgotPassword = false;
  bool _showRecoveryConfirmation = false;
  DocumentType? _recoverDocType;
  final _recoverDocNumberController = TextEditingController();
  bool _recoverDocNumberTouched = false;

  bool get _canRecoverSubmit =>
      _recoverDocType != null &&
      _recoverDocNumberController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _docNumberController.dispose();
    _passwordController.dispose();
    _recoverDocNumberController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    setState(() {
      _docNumberTouched = true;
      _passwordTouched = true;
    });
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
          documentType: _selectedDocType!.code,
          documentNumber: _docNumberController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _onRecoverSubmit(BuildContext context) {
    setState(() => _recoverDocNumberTouched = true);
    if (_recoverDocType == null ||
        _recoverDocNumberController.text.trim().isEmpty) {
      return;
    }
    context.read<AuthCubit>().requestPasswordRecovery(
      identifier: _recoverDocNumberController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          widget.onLoginSuccess();
        }
        if (state.status == AuthStatus.otpSent) {
          setState(() => _showRecoveryConfirmation = true);
        }
        if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),),
              ),
            );
          context.read<AuthCubit>().clearError();
        }
      },
      builder: (context, state) {
        if (_showRecoveryConfirmation) {
          return _RecoveryConfirmationCard(onClose: widget.onClose);
        }
        if (_showForgotPassword) {
          return _RecoverPasswordCard(
            docNumberController: _recoverDocNumberController,
            selectedDocType: _recoverDocType,
            isLoading: state.isLoading,
            docNumberTouched: _recoverDocNumberTouched,
            canSubmit: _canRecoverSubmit,
            onDocTypeChanged: (t) => setState(() => _recoverDocType = t),
            onDocNumberChanged: (_) => setState(() {}),
            onSubmit: () => _onRecoverSubmit(context),
            onRegister: widget.onRegisterRequested ?? () {},
            onClose: widget.onClose,
          );
        }
        return _LoginCard(
          formKey: _formKey,
          docNumberController: _docNumberController,
          passwordController: _passwordController,
          selectedDocType: _selectedDocType,
          rememberMe: _rememberMe,
          obscurePassword: _obscurePassword,
          isLoading: state.isLoading,
          docNumberTouched: _docNumberTouched,
          passwordTouched: _passwordTouched,
          canSubmit: _canSubmit,
          onDocTypeChanged: (t) => setState(() => _selectedDocType = t),
          onRememberChanged: (v) => setState(() => _rememberMe = v ?? false),
          onTogglePassword: () =>
              setState(() => _obscurePassword = !_obscurePassword),
          onDocNumberChanged: (_) => setState(() {}),
          onPasswordChanged: (_) => setState(() {}),
          onSubmit: () => _onSubmit(context),
          onForgotPassword: () =>
              setState(() => _showForgotPassword = true),
          onRegister: widget.onRegisterRequested ?? () {},
          onClose: widget.onClose,
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// LoginScreen — full-page route wrapper (acceso directo por URL /login)
// ──────────────────────────────────────────────────────────────────────────────

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Stack(
        children: [
          const _PageBackground(),
          Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: LoginFormWidget(
                onClose: () => context.go(AppRoutes.home),
                onLoginSuccess: () => context.go(AppRoutes.home),
                onRecoveryRequested: (identifier) => context.push(
                  AppRoutes.otpVerification,
                  extra: {
                    'destination': identifier,
                    'flow': OtpFlow.passwordRecovery,
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Fondo página full-page
// ──────────────────────────────────────────────────────────────────────────────

class _PageBackground extends StatelessWidget {
  const _PageBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary700.withValues(alpha: 0.95),
            AppColors.pageBackground,
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Modal Card — Figma 561:8743
// Canvas 1728px → modal 704px (40.7%). Se escala al viewport actual.
// ──────────────────────────────────────────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.docNumberController,
    required this.passwordController,
    required this.selectedDocType,
    required this.rememberMe,
    required this.obscurePassword,
    required this.isLoading,
    required this.docNumberTouched,
    required this.passwordTouched,
    required this.canSubmit,
    required this.onDocTypeChanged,
    required this.onRememberChanged,
    required this.onTogglePassword,
    required this.onDocNumberChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onRegister,
    required this.onClose,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController docNumberController;
  final TextEditingController passwordController;
  final DocumentType? selectedDocType;
  final bool rememberMe;
  final bool obscurePassword;
  final bool isLoading;
  final bool docNumberTouched;
  final bool passwordTouched;
  final bool canSubmit;

  final ValueChanged<DocumentType?> onDocTypeChanged;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback onTogglePassword;
  final ValueChanged<String> onDocNumberChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    // Figma canvas: 1728px · modal: 704px (ratio 40.74%)
    // Escala proporcional al viewport para mantener las proporciones del Figma.
    final double screenWidth = MediaQuery.of(context).size.width;
    final double modalWidth =
        (screenWidth * (704.0 / 1728.0)).clamp(360.0, 704.0);
    final double scale = modalWidth / 704.0;
    final double inputW = (320.0 * scale).clamp(240.0, 320.0);
    final double buttonW = (371.0 * scale).clamp(270.0, 371.0);
    final double logoW = (294.0 * scale).clamp(180.0, 294.0);
    final double logoH = (129.0 * scale).clamp(56.0, 129.0);

    return Container(
      width: modalWidth,
      decoration: BoxDecoration(
        color: AppColors.secondary500,
        borderRadius: BorderRadius.circular(38),
        boxShadow: AppColors.sombra200,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Botón cerrar ───────────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: _CloseButton(onClose: onClose),
              ),
              const SizedBox(height: 4),

              // ── Logo Gane (SVG real del proyecto) ──────────────────────────
              _LoginLogo(logoWidth: logoW, logoHeight: logoH),
              const SizedBox(height: 8),

              // ── Título ─────────────────────────────────────────────────────
              Text(
                'Ingresa tus datos',
                style: GoogleFonts.inter(
                  fontSize: 20 * scale,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralWhite,
                ),
              ),
              const SizedBox(height: 10),

              // ── Tipo de documento ──────────────────────────────────────────
              SizedBox(
                width: inputW,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FormLabel(text: 'Tipo de documento*', scale: scale),
                    const SizedBox(height: 1),
                    _DocTypeDropdown(
                      value: selectedDocType,
                      enabled: !isLoading,
                      onChanged: onDocTypeChanged,
                      // Error visible solo tras intento de envío (docNumberTouched
                      // se activa junto con el resto de campos en _onSubmit)
                      errorText: docNumberTouched && selectedDocType == null
                          ? 'Selecciona el tipo de documento.'
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ── Número de documento ────────────────────────────────────────
              SizedBox(
                width: inputW,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FormLabel(text: 'Número de documento*', scale: scale),
                    const SizedBox(height: 1),
                    _FormInput(
                      controller: docNumberController,
                      hint: 'Ingresa un número',
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      onChanged: onDocNumberChanged,
                      validator: docNumberTouched
                          ? (v) =>
                              Validators.documentNumber(v, selectedDocType)
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ── Contraseña ─────────────────────────────────────────────────
              SizedBox(
                width: inputW,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FormLabel(text: 'Contraseña*', scale: scale),
                    const SizedBox(height: 1),
                    _PasswordInput(
                      controller: passwordController,
                      obscure: obscurePassword,
                      enabled: !isLoading,
                      onToggle: onTogglePassword,
                      onChanged: onPasswordChanged,
                      onSubmitted: (_) => onSubmit(),
                      validator: passwordTouched ? Validators.password : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ── Recordar mis datos ─────────────────────────────────────────
              _RememberMeRow(
                value: rememberMe,
                enabled: !isLoading,
                onChanged: onRememberChanged,
                scale: scale,
              ),
              const SizedBox(height: 10),

              // ── Botón Ingresar ─────────────────────────────────────────────
              _LoginButton(
                onPressed: onSubmit,
                isLoading: isLoading,
                canSubmit: canSubmit,
                width: buttonW,
                scale: scale,
              ),
              const SizedBox(height: 6),

              // ── Olvidé mi contraseña ───────────────────────────────────────
              TextButton(
                onPressed: isLoading ? null : onForgotPassword,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Olvidé mi contraseña',
                  style: GoogleFonts.poppins(
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.w400,
                    height: 20 / 12,
                    color: AppColors.neutralWhite,
                  ),
                ),
              ),
              const SizedBox(height: 2),

              // ── ¿No tienes cuenta? ─────────────────────────────────────────
              GestureDetector(
                onTap: isLoading ? null : onRegister,
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w400,
                      height: 20 / 12,
                      color: AppColors.neutralWhite,
                    ),
                    children: const [
                      TextSpan(text: '¿No tienes cuenta? '),
                      TextSpan(
                        text: 'regístrate aquí',
                        style: TextStyle(color: Color(0xFFFFCC00)),
                      ),
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
// Logo del modal — SVG real de Gane + texto "Bienvenido"
// Misma fuente del logo que usa el navbar (AppAssets.logoGane)
// ──────────────────────────────────────────────────────────────────────────────

class _LoginLogo extends StatelessWidget {
  const _LoginLogo({required this.logoWidth, required this.logoHeight});

  final double logoWidth;
  final double logoHeight;

  @override
  Widget build(BuildContext context) {
    final double scale = logoWidth / 294.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Bienvenido',
          style: GoogleFonts.inter(
            fontSize: 24 * scale,
            fontWeight: FontWeight.w600,
            color: AppColors.neutralWhite,
          ),
        ),
        const SizedBox(height: 6),
        SvgPicture.asset(
          AppAssets.logoGane,
          width: logoWidth,
          height: logoHeight,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ──────────────────────────────────────────────────────────────────────────────

class _FormLabel extends StatelessWidget {
  const _FormLabel({required this.text, this.scale = 1.0});
  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w600,
        height: 24 / 14,
        color: AppColors.neutralWhite.withValues(alpha: 0.8),
      ),
    );
  }
}

class _DocTypeDropdown extends StatelessWidget {
  const _DocTypeDropdown({
    required this.value,
    required this.onChanged,
    required this.enabled,
    this.errorText,
  });

  final DocumentType? value;
  final ValueChanged<DocumentType?> onChanged;
  final bool enabled;
  // Texto de error externo (calculado por el padre tras intentar enviar el form)
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<DocumentType>(
          initialValue: value,
          onChanged: enabled ? onChanged : null,
          validator: (v) =>
              v == null ? 'Selecciona el tipo de documento.' : null,
          hint: Text(
            'Selecciona tu documento',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.neutralBlack.withValues(alpha: 0.5),
            ),
          ),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralBlack,
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.neutral5, size: 20,),
          dropdownColor: AppColors.modalBackground,
          isExpanded: true,
          decoration: _loginInputDecoration(hasError: hasError),
          items: DocumentType.values
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(
                    t.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.neutralBlack,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if (hasError) ...[
          const SizedBox(height: 1),
          InputErrorBox(errorText: errorText!),
        ],
      ],
    );
  }
}

class _FormInput extends StatelessWidget {
  const _FormInput({
    required this.controller,
    required this.hint,
    required this.enabled,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final String? errorText = validator?.call(controller.text);
    final bool hasError = errorText != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralBlack,
          ),
          decoration: _loginInputDecoration(hint: hint, hasError: hasError),
        ),
        if (hasError) ...[
          const SizedBox(height: 1),
          InputErrorBox(errorText: errorText),
        ],
      ],
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    required this.controller,
    required this.obscure,
    required this.enabled,
    required this.onToggle,
    this.onChanged,
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final bool obscure;
  final bool enabled;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final String? errorText = validator?.call(controller.text);
    final bool hasError = errorText != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscure,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralBlack,
          ),
          decoration: _loginInputDecoration(
            hint: '••••••••••••••',
            hasError: hasError,
          ).copyWith(
            // Contraseña: borde gris visible (Figma: 1px solid #858C94)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColors.neutral5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color:
                    hasError ? AppColors.inputBorderError : AppColors.neutral5,
              ),
            ),
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
        if (hasError) ...[
          const SizedBox(height: 1),
          InputErrorBox(errorText: errorText),
        ],
      ],
    );
  }
}

class _RememberMeRow extends StatelessWidget {
  const _RememberMeRow({
    required this.value,
    required this.onChanged,
    required this.enabled,
    this.scale = 1.0,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool enabled;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: AppColors.primary700,
            checkColor: AppColors.neutralWhite,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),),
            side: const BorderSide(
                color: AppColors.neutralWhite, width: 1.5,),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Recordar mis datos',
          style: GoogleFonts.inter(
            fontSize: 14 * scale,
            fontWeight: FontWeight.w400,
            color: AppColors.neutralWhite,
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onPressed,
    required this.isLoading,
    required this.canSubmit,
    required this.width,
    this.scale = 1.0,
    this.label = 'Ingresar',
  });

  final VoidCallback onPressed;
  final bool isLoading;
  final bool canSubmit;
  final double width;
  final double scale;
  final String label;

  @override
  Widget build(BuildContext context) {
    final bool active = canSubmit && !isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: (57 * scale).clamp(44.0, 57.0),
      decoration: BoxDecoration(
        color: active ? AppColors.secondary300 : const Color(0xFFD7D7D7),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(26),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.neutralWhite,
                    ),
                  )
                : Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: (20 * scale).clamp(14.0, 20.0),
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

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.close_rounded,
          size: 24,
          color: AppColors.neutralWhite,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Confirmación de recuperación — Figma 561:10417
// Solo logo + título + texto informativo. Sin inputs ni botón.
// ──────────────────────────────────────────────────────────────────────────────

class _RecoveryConfirmationCard extends StatelessWidget {
  const _RecoveryConfirmationCard({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double modalWidth =
        (screenWidth * (704.0 / 1728.0)).clamp(360.0, 704.0);
    final double scale = modalWidth / 704.0;
    final double logoW = (294.0 * scale).clamp(180.0, 294.0);
    final double logoH = (129.0 * scale).clamp(56.0, 129.0);
    // Figma: texto w-[556px] dentro del modal de 704px
    final double textW = (556.0 * scale).clamp(280.0, 556.0);

    return Container(
      width: modalWidth,
      decoration: BoxDecoration(
        color: AppColors.secondary500,
        borderRadius: BorderRadius.circular(38),
        boxShadow: AppColors.sombra200,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Botón cerrar ───────────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: _CloseButton(onClose: onClose),
            ),
            const SizedBox(height: 4),

            // ── Logo Gane ──────────────────────────────────────────────────
            _LoginLogo(logoWidth: logoW, logoHeight: logoH),
            const SizedBox(height: 20),

            // ── Título ─────────────────────────────────────────────────────
            Text(
              'Olvidé mi contraseña',
              style: GoogleFonts.inter(
                fontSize: 20 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.neutralWhite,
              ),
            ),
            const SizedBox(height: 20),

            // ── Texto informativo (Figma: Inter Regular 16px, w-556px) ─────
            SizedBox(
              width: textW,
              child: Text(
                'Hemos enviado un correo electrónico con las instrucciones '
                'para recuperar tu contraseña. Por favor revisa tu bandeja '
                'de entrada y sigue los pasos indicados.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: AppColors.neutralWhite,
                ),
              ),
            ),

            // Espacio inferior equivalente al placeholder vacío del Figma
            SizedBox(height: (73 * scale).clamp(40.0, 73.0)),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Recuperar contraseña — Figma 561:10208
// Mismo container que el login, contenido más corto (sin password ni remember).
// ──────────────────────────────────────────────────────────────────────────────

class _RecoverPasswordCard extends StatelessWidget {
  const _RecoverPasswordCard({
    required this.docNumberController,
    required this.selectedDocType,
    required this.isLoading,
    required this.docNumberTouched,
    required this.canSubmit,
    required this.onDocTypeChanged,
    required this.onDocNumberChanged,
    required this.onSubmit,
    required this.onRegister,
    required this.onClose,
  });

  final TextEditingController docNumberController;
  final DocumentType? selectedDocType;
  final bool isLoading;
  final bool docNumberTouched;
  final bool canSubmit;
  final ValueChanged<DocumentType?> onDocTypeChanged;
  final ValueChanged<String> onDocNumberChanged;
  final VoidCallback onSubmit;
  final VoidCallback onRegister;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double modalWidth =
        (screenWidth * (704.0 / 1728.0)).clamp(360.0, 704.0);
    final double scale = modalWidth / 704.0;
    final double inputW = (320.0 * scale).clamp(240.0, 320.0);
    final double buttonW = (371.0 * scale).clamp(270.0, 371.0);
    final double logoW = (294.0 * scale).clamp(180.0, 294.0);
    final double logoH = (129.0 * scale).clamp(56.0, 129.0);

    return Container(
      width: modalWidth,
      decoration: BoxDecoration(
        color: AppColors.secondary500,
        borderRadius: BorderRadius.circular(38),
        boxShadow: AppColors.sombra200,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Botón cerrar ───────────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: _CloseButton(onClose: onClose),
            ),
            const SizedBox(height: 4),

            // ── Logo Gane ──────────────────────────────────────────────────
            _LoginLogo(logoWidth: logoW, logoHeight: logoH),
            const SizedBox(height: 8),

            // ── Título ─────────────────────────────────────────────────────
            Text(
              'Olvidé mi contraseña',
              style: GoogleFonts.inter(
                fontSize: 20 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.neutralWhite,
              ),
            ),
            const SizedBox(height: 20),

            // ── Tipo de documento ──────────────────────────────────────────
            SizedBox(
              width: inputW,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FormLabel(text: 'Tipo de documento*', scale: scale),
                  const SizedBox(height: 1),
                  _DocTypeDropdown(
                    value: selectedDocType,
                    enabled: !isLoading,
                    onChanged: onDocTypeChanged,
                    errorText: docNumberTouched && selectedDocType == null
                        ? 'Selecciona el tipo de documento.'
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Número de documento ────────────────────────────────────────
            SizedBox(
              width: inputW,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FormLabel(text: 'Número de documento*', scale: scale),
                  const SizedBox(height: 1),
                  _FormInput(
                    controller: docNumberController,
                    hint: 'Ingresa un número',
                    enabled: !isLoading,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.done,
                    onChanged: onDocNumberChanged,
                    validator: docNumberTouched
                        ? (v) => Validators.documentNumber(v, selectedDocType)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Botón Recuperar contraseña ─────────────────────────────────
            _LoginButton(
              onPressed: onSubmit,
              isLoading: isLoading,
              canSubmit: canSubmit,
              width: buttonW,
              scale: scale,
              label: 'Recuperar contraseña',
            ),
            const SizedBox(height: 6),

            // ── ¿No tienes cuenta? ─────────────────────────────────────────
            GestureDetector(
              onTap: isLoading ? null : onRegister,
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.w400,
                    height: 20 / 12,
                    color: AppColors.neutralWhite,
                  ),
                  children: const [
                    TextSpan(text: '¿No tienes cuenta? '),
                    TextSpan(
                      text: 'regístrate aquí',
                      style: TextStyle(color: Color(0xFFFFCC00)),
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

// ──────────────────────────────────────────────────────────────────────────────
// Decoración de inputs del modal — rounded-30px · bg blanco · hint oscuro 50%
// ──────────────────────────────────────────────────────────────────────────────

InputDecoration _loginInputDecoration({
  String? hint,
  required bool hasError,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.inter(
      fontSize: 14,
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
      borderSide: const BorderSide(color: AppColors.inputBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: hasError ? AppColors.inputBorderError : AppColors.inputBorder,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: hasError
            ? AppColors.inputBorderError
            : AppColors.inputBorderFocus,
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
          color: AppColors.inputBorderError, width: 1.5,),
    ),
    // El texto de error nativo se oculta — se muestra con InputErrorBox
    errorStyle: const TextStyle(height: 0, fontSize: 0.01),
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    errorMaxLines: 1,
  );
}

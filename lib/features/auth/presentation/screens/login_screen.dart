import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/document_type.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/gane_logo_widget.dart';

// ──────────────────────────────────────────────────────────────────────────────
// LoginScreen
// Figma: plataforma-Gane-Web · node 561:8741 "Inicio de sesión"
// Patrón: modal dialog overlay sobre fondo oscuro (landing page)
// ──────────────────────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _docNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  DocumentType? _selectedDocType;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  // Tracking de campos tocados para mostrar errores inline (skill §Step 5)
  bool _docNumberTouched = false;
  bool _passwordTouched = false;

  bool get _canSubmit =>
      _selectedDocType != null &&
      _docNumberController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _docNumberController.dispose();
    _passwordController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo: navy oscuro representando la landing page detrás del modal
      backgroundColor: AppColors.pageBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            context.go(AppRoutes.home);
          }
          if (state.status == AuthStatus.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            context.read<AuthCubit>().clearError();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Fondo con gradiente navy (simula la página detrás del modal)
              _PageBackground(),

              // Modal centrado
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 32),
                  child: _LoginCard(
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
                    onDocTypeChanged: (t) =>
                        setState(() => _selectedDocType = t),
                    onRememberChanged: (v) =>
                        setState(() => _rememberMe = v ?? false),
                    onTogglePassword: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    onDocNumberChanged: (_) => setState(() {}),
                    onPasswordChanged: (_) => setState(() {}),
                    onSubmit: () => _onSubmit(context),
                    onForgotPassword: () =>
                        context.push(AppRoutes.recoverPassword),
                    onRegister: () {
                      // TODO: navegar a pantalla de registro cuando esté disponible
                    },
                    onClose: () => context.go(AppRoutes.home),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Fondo
// ──────────────────────────────────────────────────────────────────────────────

class _PageBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary700.withOpacity(0.95),
            AppColors.pageBackground,
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Modal Card principal
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
    return Container(
      width: 420,
      decoration: BoxDecoration(
        color: AppColors.modalBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.sombra200,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  const Center(child: GaneLogoWidget(size: 72)),
                  const SizedBox(height: 20),

                  // Título
                  Center(
                    child: Text(
                      'Ingresa tus datos',
                      style: AppTextStyles.h3Bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Tipo de documento ──────────────────────────────────
                  _FormLabel(text: 'Tipo de documento*'),
                  const SizedBox(height: 6),
                  _DocTypeDropdown(
                    value: selectedDocType,
                    enabled: !isLoading,
                    onChanged: onDocTypeChanged,
                  ),
                  const SizedBox(height: 16),

                  // ── Número de documento ────────────────────────────────
                  _FormLabel(text: 'Número de documento*'),
                  const SizedBox(height: 6),
                  _FormInput(
                    controller: docNumberController,
                    hint: 'Ingresa un número',
                    enabled: !isLoading,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.next,
                    onChanged: onDocNumberChanged,
                    validator: docNumberTouched
                        ? (v) => Validators.documentNumber(v, selectedDocType)
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Contraseña ─────────────────────────────────────────
                  _FormLabel(text: 'Contraseña*'),
                  const SizedBox(height: 6),
                  _PasswordInput(
                    controller: passwordController,
                    obscure: obscurePassword,
                    enabled: !isLoading,
                    onToggle: onTogglePassword,
                    onChanged: onPasswordChanged,
                    onSubmitted: (_) => onSubmit(),
                    validator: passwordTouched ? Validators.password : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Recordar mis datos ─────────────────────────────────
                  _RememberMeRow(
                    value: rememberMe,
                    enabled: !isLoading,
                    onChanged: onRememberChanged,
                  ),
                  const SizedBox(height: 24),

                  // ── Botón Ingresar ─────────────────────────────────────
                  _LoginButton(
                    onPressed: onSubmit,
                    isLoading: isLoading,
                    canSubmit: canSubmit,
                  ),
                  const SizedBox(height: 16),

                  // ── Olvidé mi contraseña ───────────────────────────────
                  Center(
                    child: TextButton(
                      onPressed: isLoading ? null : onForgotPassword,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 36),
                      ),
                      child: Text(
                        'Olvidé mi contraseña',
                        style: AppTextStyles.linkSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── ¿No tienes cuenta? ─────────────────────────────────
                  Center(
                    child: GestureDetector(
                      onTap: isLoading ? null : onRegister,
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.linkSecondary,
                          children: [
                            const TextSpan(text: '¿No tienes cuenta? '),
                            TextSpan(
                              text: 'regístrate aquí',
                              style: AppTextStyles.linkGold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Botón cerrar (X) ───────────────────────────────────────────
          Positioned(
            top: 12,
            right: 12,
            child: _CloseButton(onClose: onClose),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ──────────────────────────────────────────────────────────────────────────────

class _FormLabel extends StatelessWidget {
  const _FormLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.formLabel);
  }
}

class _DocTypeDropdown extends StatelessWidget {
  const _DocTypeDropdown({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final DocumentType? value;
  final ValueChanged<DocumentType?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<DocumentType>(
      value: value,
      onChanged: enabled ? onChanged : null,
      validator: (v) => v == null ? 'Selecciona el tipo de documento.' : null,
      hint: Text('Selecciona tu documento', style: AppTextStyles.inputHint),
      style: AppTextStyles.inputText,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.neutral5, size: 20),
      dropdownColor: AppColors.modalBackground,
      isExpanded: true,
      decoration: _inputDecoration(hasError: false),
      items: DocumentType.values
          .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t.label, style: AppTextStyles.inputText),
              ))
          .toList(),
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
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: AppTextStyles.inputText,
      decoration: _inputDecoration(
        hint: hint,
        hasError:
            validator != null && validator!(controller.text) != null,
      ),
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
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscure,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: AppTextStyles.inputText,
      decoration: _inputDecoration(
        hint: '••••••••••••••',
        hasError:
            validator != null && validator!(controller.text) != null,
      ).copyWith(
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
    );
  }
}

class _RememberMeRow extends StatelessWidget {
  const _RememberMeRow({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: AppColors.secondary500,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(color: AppColors.inputBorder, width: 1.5),
          ),
        ),
        const SizedBox(width: 10),
        Text('Recordar mis datos', style: AppTextStyles.inputText),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onPressed,
    required this.isLoading,
    required this.canSubmit,
  });

  final VoidCallback onPressed;
  final bool isLoading;
  final bool canSubmit;

  @override
  Widget build(BuildContext context) {
    final active = canSubmit && !isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      decoration: BoxDecoration(
        color: active ? AppColors.secondary500 : AppColors.buttonDisabled,
        borderRadius: BorderRadius.circular(100), // pill
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(100),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.neutralWhite,
                    ),
                  )
                : Text(
                    'Ingresar',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: active
                          ? AppColors.neutralWhite
                          : AppColors.buttonDisabledText,
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
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: const Icon(Icons.close_rounded,
            size: 16, color: AppColors.neutral3),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Helper: decoración común para inputs del formulario
// ──────────────────────────────────────────────────────────────────────────────

InputDecoration _inputDecoration({String? hint, required bool hasError}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.inputHint,
    filled: true,
    fillColor: AppColors.inputFill,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          const BorderSide(color: AppColors.inputBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: hasError
            ? AppColors.inputBorderError
            : AppColors.inputBorder,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: hasError
            ? AppColors.inputBorderError
            : AppColors.inputBorderFocus,
        width: 1.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          const BorderSide(color: AppColors.inputBorderError),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          const BorderSide(color: AppColors.inputBorderError, width: 1.5),
    ),
    errorStyle: AppTextStyles.errorText,
    // ícono rojo antes del mensaje de error (igual al diseño Figma)
    prefixIconConstraints:
        const BoxConstraints(minWidth: 0, minHeight: 0),
    errorMaxLines: 2,
  );
}

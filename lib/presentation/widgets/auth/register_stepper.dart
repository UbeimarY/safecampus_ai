import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.riskLow.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterHeader extends StatelessWidget {
  final VoidCallback onBack;
  final String title;
  final String subtitle;
  final int stepIndex;
  final int totalSteps;

  const RegisterHeader({
    super.key,
    required this.onBack,
    required this.title,
    required this.subtitle,
    required this.stepIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  title,
                  key: ValueKey(stepIndex),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  subtitle,
                  key: ValueKey('sub_$stepIndex'),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '${stepIndex + 1}/$totalSteps',
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterProgressBar extends StatelessWidget {
  final int stepIndex;
  final int totalSteps;

  const RegisterProgressBar({
    super.key,
    required this.stepIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: (stepIndex + 1) / totalSteps,
          backgroundColor: Colors.white12,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          minHeight: 6,
        ),
      ),
    );
  }
}

class RegisterStepIndicators extends StatelessWidget {
  final int stepIndex;
  final List<IconData> icons;

  const RegisterStepIndicators({
    super.key,
    required this.stepIndex,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(icons.length, (index) {
          final isCompleted = index < stepIndex;
          final isActive = index == stepIndex;
          return Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.riskLow
                        : isActive
                            ? AppColors.accent
                            : AppColors.surface,
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.riskLow
                          : isActive
                              ? AppColors.accent
                              : Colors.white24,
                      width: 2,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_rounded : icons[index],
                    size: 18,
                    color: isCompleted || isActive ? Colors.white : Colors.white38,
                  ),
                ),
                if (index < icons.length - 1)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 2,
                      color:
                          index < stepIndex ? AppColors.riskLow : Colors.white12,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class RegisterNavigation extends StatelessWidget {
  final bool isLoading;
  final bool isLastStep;
  final VoidCallback onContinue;
  final VoidCallback onGoToLogin;
  final bool showLoginLink;

  const RegisterNavigation({
    super.key,
    required this.isLoading,
    required this.isLastStep,
    required this.onContinue,
    required this.onGoToLogin,
    required this.showLoginLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 6,
                shadowColor: AppColors.accent.withValues(alpha: 0.4),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.black,
                      ),
                    )
                  : Text(
                      isLastStep ? 'Crear mi cuenta' : 'Continuar',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          if (showLoginLink)
            GestureDetector(
              onTap: onGoToLogin,
              child: const Text.rich(
                TextSpan(
                  text: '¿Ya tienes cuenta? ',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: 'Inicia sesión',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const RegisterTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
        filled: true,
        fillColor: AppColors.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: AppColors.riskHigh, fontSize: 12),
      ),
    );
  }
}

class RegisterPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const RegisterPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.accent,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: AppColors.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: AppColors.riskHigh, fontSize: 12),
      ),
    );
  }
}

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    int strength = 0;
    if (password.length >= 6) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*]'))) strength++;

    final colors = [
      AppColors.riskHigh,
      AppColors.riskMedium,
      AppColors.riskLow,
      AppColors.accent,
    ];

    final labels = ['Débil', 'Regular', 'Buena', 'Fuerte'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i < strength ? colors[strength - 1] : Colors.white12,
                ),
              ),
            );
          }),
        ),
        if (password.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            'Contraseña: ${labels[strength > 0 ? strength - 1 : 0]}',
            style: TextStyle(
              color: strength > 0 ? colors[strength - 1] : Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

class AccountSummary extends StatelessWidget {
  final String fullName;
  final String phone;
  final String email;

  const AccountSummary({
    super.key,
    required this.fullName,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de cuenta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            icon: Icons.person_rounded,
            label: 'Nombre',
            value: fullName,
          ),
          const Divider(color: Colors.white12, height: 20),
          _SummaryRow(
            icon: Icons.phone_rounded,
            label: 'Teléfono',
            value: phone,
          ),
          const Divider(color: Colors.white12, height: 20),
          _SummaryRow(
            icon: Icons.email_outlined,
            label: 'Correo',
            value: email,
          ),
        ],
      ),
    );
  }
}

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final VoidCallback onToggle;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              value ? AppColors.accent.withValues(alpha: 0.4) : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: value ? AppColors.accent : Colors.transparent,
                border: Border.all(
                  color: value ? AppColors.accent : Colors.white38,
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: 'Acepto los '),
                  TextSpan(
                    text: 'Términos y Condiciones',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' y la '),
                  TextSpan(
                    text: 'Política de Privacidad',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' de SafeCampus AI.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterPersonalStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;

  const RegisterPersonalStep({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: const Duration(milliseconds: 400),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cardColor,
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 44,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RegisterTextField(
                controller: firstNameController,
                hintText: 'Nombres',
                icon: Icons.badge_rounded,
                validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tus nombres' : null,
              ),
              const SizedBox(height: 14),
              RegisterTextField(
                controller: lastNameController,
                hintText: 'Apellidos',
                icon: Icons.badge_outlined,
                validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tus apellidos' : null,
              ),
              const SizedBox(height: 14),
              RegisterTextField(
                controller: phoneController,
                hintText: 'Teléfono',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa tu teléfono';
                  if (v.length < 10) return 'Teléfono inválido';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterAccountStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  const RegisterAccountStep({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: const Duration(milliseconds: 400),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardColor,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    size: 40,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RegisterTextField(
                controller: emailController,
                hintText: 'Correo electrónico',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa tu correo';
                  if (!v.contains('@')) return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              RegisterPasswordField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: obscurePassword,
                onToggle: onTogglePassword,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                  if (v.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              RegisterPasswordField(
                controller: confirmPasswordController,
                hintText: 'Confirmar contraseña',
                obscureText: obscureConfirmPassword,
                onToggle: onToggleConfirmPassword,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                  if (v != passwordController.text) return 'Las contraseñas no coinciden';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PasswordStrengthIndicator(password: passwordController.text),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterConfirmationStep extends StatelessWidget {
  final String fullName;
  final String phone;
  final String email;
  final bool hasAcceptedTerms;
  final VoidCallback onToggleTerms;

  const RegisterConfirmationStep({
    super.key,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.hasAcceptedTerms,
    required this.onToggleTerms,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: const Duration(milliseconds: 400),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          children: [
            FadeInDown(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            AccountSummary(fullName: fullName, phone: phone, email: email),
            const SizedBox(height: 16),
            TermsCheckbox(value: hasAcceptedTerms, onToggle: onToggleTerms),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value.isEmpty ? '—' : value;
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            Text(
              displayValue,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


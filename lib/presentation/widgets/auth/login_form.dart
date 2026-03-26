import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onBiometricSignIn;
  final VoidCallback onGoToRegister;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    required this.isLoading,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onGoogleSignIn,
    required this.onBiometricSignIn,
    required this.onGoToRegister,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.15),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.login,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                AppStrings.welcomeBack,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              _EmailField(controller: emailController),
              const SizedBox(height: 14),
              _PasswordField(
                controller: passwordController,
                obscurePassword: obscurePassword,
                onTogglePasswordVisibility: onTogglePasswordVisibility,
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onForgotPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  child: const Text(
                    AppStrings.forgotPassword,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _PrimaryButton(
                isLoading: isLoading,
                onPressed: onSubmit,
              ),
              const SizedBox(height: 20),
              const _Divider(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Inicio de sesión con Google en desarrollo')),
                        );
                        if (!isLoading) onGoogleSignIn();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(
                        Icons.g_mobiledata_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      label: const Text(
                        'Google',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Inicio de sesión biométrico en desarrollo')),
                        );
                        if (!isLoading) onBiometricSignIn();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(
                          color: AppColors.accent.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(
                        Icons.fingerprint_rounded,
                        color: AppColors.accent,
                        size: 22,
                      ),
                      label: const Text(
                        'Biometrics',
                        style:
                            TextStyle(color: AppColors.accent, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: onGoToRegister,
                  child: RichText(
                    text: const TextSpan(
                      text: '${AppStrings.noAccount} ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.signUp,
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: AppStrings.email,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.accent),
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
        errorStyle: const TextStyle(color: AppColors.riskHigh),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return AppStrings.enterEmail;
        if (!value.contains('@')) return AppStrings.invalidEmail;
        return null;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;

  const _PasswordField({
    required this.controller,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscurePassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: AppStrings.password,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon:
            const Icon(Icons.lock_outline_rounded, color: AppColors.accent),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: onTogglePasswordVisibility,
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
        errorStyle: const TextStyle(color: AppColors.riskHigh),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return AppStrings.enterPassword;
        if (value.length < 6) return 'Minimum 6 characters';
        return null;
      },
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
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
            : const Text(
                AppStrings.login,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.white12)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white12)),
      ],
    );
  }
}


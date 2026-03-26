import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_states.dart';
import '../../logic/auth/auth_controller.dart';
import '../../widgets/auth/login_background.dart';
import '../../widgets/auth/login_form.dart';
import '../../widgets/auth/login_header.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  Future<void> _googleSignIn() async {
    await ref.read(authControllerProvider.notifier).mockGoogleSignIn();
  }

  Future<void> _biometricSignIn() async {
    await ref.read(authControllerProvider.notifier).mockBiometricSignIn();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthUiState>(authControllerProvider, (previous, next) {
      if (previous?.status == next.status) return;

      if (next.status == AsyncStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.riskHigh,
          ),
        );
        ref.read(authControllerProvider.notifier).reset();
      }

      if (next.status == AsyncStatus.success) {
        ref.read(authControllerProvider.notifier).reset();
        context.go('/mapa');
      }
    });

    final isLoading =
        ref.watch(authControllerProvider).status == AsyncStatus.loading;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const LoginBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const LoginHeader(),
                      const SizedBox(height: 32),
                      Expanded(
                        child: LoginForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          onTogglePasswordVisibility: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          isLoading: isLoading,
                          onSubmit: _signIn,
                          onForgotPassword: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Función de recuperación de contraseña en desarrollo')),
                            );
                          },
                          onGoogleSignIn: _googleSignIn,
                          onBiometricSignIn: _biometricSignIn,
                          onGoToRegister: () => context.go('/registro'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

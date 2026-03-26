import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_states.dart';
import '../../logic/auth/register_controller.dart';
import '../../widgets/auth/register_stepper.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final PageController _pageController = PageController();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _personalFormKey = GlobalKey<FormState>();
  final _accountFormKey = GlobalKey<FormState>();

  static const _stepTitles = [
    'Datos personales',
    'Cuenta segura',
    'Confirmación',
  ];

  static const _stepSubtitles = [
    'Cuéntanos quién eres',
    'Crea tus credenciales',
    'Casi listo',
  ];

  static const _stepIcons = [
    Icons.person_rounded,
    Icons.lock_rounded,
    Icons.verified_user_rounded,
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _continue() {
    final controller = ref.read(registerControllerProvider.notifier);
    final stepIndex = ref.read(registerControllerProvider).stepIndex;
    bool valid = false;
    if (stepIndex == 0) valid = _personalFormKey.currentState!.validate();
    if (stepIndex == 1) valid = _accountFormKey.currentState!.validate();
    if (stepIndex == 2) valid = true;

    if (!valid) return;

    if (stepIndex < 2) {
      controller.nextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      controller.submit(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
      );
    }
  }

  void _back() {
    final controller = ref.read(registerControllerProvider.notifier);
    final stepIndex = ref.read(registerControllerProvider).stepIndex;
    if (stepIndex > 0) {
      controller.previousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RegisterState>(registerControllerProvider, (previous, next) {
      if (previous?.status == next.status && previous?.stepIndex == next.stepIndex) {
        return;
      }

      if (next.status == AsyncStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.riskHigh,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }

      if (next.status == AsyncStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso. Ya puedes iniciar sesión.'),
            backgroundColor: AppColors.riskLow,
          ),
        );
        ref.read(registerControllerProvider.notifier).reset();
        context.go('/login');
      }
    });

    final registerState = ref.watch(registerControllerProvider);
    final stepIndex = registerState.stepIndex;
    final isLoading = registerState.status == AsyncStatus.loading;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const RegisterBackground(),
          SafeArea(
            child: Column(
              children: [
                RegisterHeader(
                  onBack: _back,
                  title: _stepTitles[stepIndex],
                  subtitle: _stepSubtitles[stepIndex],
                  stepIndex: stepIndex,
                  totalSteps: _stepTitles.length,
                ),
                RegisterProgressBar(
                  stepIndex: stepIndex,
                  totalSteps: _stepTitles.length,
                ),

                const SizedBox(height: 8),

                RegisterStepIndicators(
                  stepIndex: stepIndex,
                  icons: _stepIcons,
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      RegisterPersonalStep(
                        formKey: _personalFormKey,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        phoneController: _phoneController,
                      ),
                      RegisterAccountStep(
                        formKey: _accountFormKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        obscurePassword: _obscurePassword,
                        obscureConfirmPassword: _obscureConfirmPassword,
                        onTogglePassword: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        onToggleConfirmPassword: () => setState(
                          () =>
                              _obscureConfirmPassword = !_obscureConfirmPassword,
                        ),
                      ),
                      RegisterConfirmationStep(
                        fullName:
                            '${_firstNameController.text} ${_lastNameController.text}'
                                .trim(),
                        phone: _phoneController.text,
                        email: _emailController.text,
                        hasAcceptedTerms: registerState.hasAcceptedTerms,
                        onToggleTerms: () => ref
                            .read(registerControllerProvider.notifier)
                            .setAcceptedTerms(!registerState.hasAcceptedTerms),
                      ),
                    ],
                  ),
                ),

                RegisterNavigation(
                  isLoading: isLoading,
                  isLastStep: stepIndex == _stepTitles.length - 1,
                  onContinue: _continue,
                  onGoToLogin: () => context.go('/login'),
                  showLoginLink: stepIndex == 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

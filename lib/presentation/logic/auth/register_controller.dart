import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_states.dart';
import 'auth_controller.dart';
import 'auth_service.dart';

final registerControllerProvider =
    StateNotifierProvider<RegisterController, RegisterState>((ref) {
  return RegisterController(ref.watch(authServiceProvider));
});

class RegisterController extends StateNotifier<RegisterState> {
  final AuthService _authService;

  RegisterController(this._authService) : super(const RegisterState());

  void setStep(int index) {
    state = state.copyWith(stepIndex: index);
  }

  void nextStep() {
    state = state.copyWith(stepIndex: state.stepIndex + 1);
  }

  void previousStep() {
    state = state.copyWith(stepIndex: state.stepIndex - 1);
  }

  void setAcceptedTerms(bool value) {
    state = state.copyWith(hasAcceptedTerms: value);
  }

  Future<void> submit({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    if (!state.hasAcceptedTerms) {
      state = state.copyWith(
        status: AsyncStatus.error,
        errorMessage: 'You must accept the terms and conditions.',
      );
      return;
    }

    state = state.copyWith(status: AsyncStatus.loading, errorMessage: null);

    try {
      final user = await _authService.signUp(
        email: email.trim(),
        password: password.trim(),
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        phone: phone.trim(),
      );

      if (user == null) {
        state = state.copyWith(
          status: AsyncStatus.error,
          errorMessage: 'Sign-up failed.',
        );
        return;
      }

      state = state.copyWith(status: AsyncStatus.success);
    } on AuthException catch (e) {
      state = state.copyWith(status: AsyncStatus.error, errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(
        status: AsyncStatus.error,
        errorMessage: 'Unexpected error.',
      );
    }
  }

  void reset() {
    state = const RegisterState();
  }
}


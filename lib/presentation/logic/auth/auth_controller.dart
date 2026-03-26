import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_states.dart';
import 'auth_service.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(supabaseClientProvider));
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthUiState>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});

class AuthController extends StateNotifier<AuthUiState> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AuthUiState());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AsyncStatus.loading, errorMessage: null);
    try {
      final user = await _authService.signInWithEmail(
        email: email.trim(),
        password: password.trim(),
      );
      if (user == null) {
        state = state.copyWith(
          status: AsyncStatus.error,
          errorMessage: 'Sign-in failed.',
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

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
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
    state = const AuthUiState();
  }

  Future<void> mockGoogleSignIn() async {
    state = state.copyWith(status: AsyncStatus.loading, errorMessage: null);
    await Future<void>.delayed(const Duration(seconds: 1));
    state = state.copyWith(status: AsyncStatus.success);
  }

  Future<void> mockBiometricSignIn() async {
    state = state.copyWith(status: AsyncStatus.loading, errorMessage: null);
    await Future<void>.delayed(const Duration(seconds: 1));
    state = state.copyWith(status: AsyncStatus.success);
  }
}

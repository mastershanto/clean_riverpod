import 'dart:async';
import 'package:clean_riverpod/features/auth/models/auth_models.dart';
import 'package:clean_riverpod/providers/auth_repository_provider.dart';
import 'package:clean_riverpod/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sign-In Controller
// ─────────────────────────────────────────────────────────────────────────────
final signInControllerProvider =
    AsyncNotifierProvider<SignInController, AuthResponse?>(
        () => SignInController());

class SignInController extends AsyncNotifier<AuthResponse?> {
  @override
  FutureOr<AuthResponse?> build() => null;

  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signIn(email, password),
    );
    if (state.value != null) {
      ref.read(currentUserProvider.notifier).setUser(state.value!);
      return true;
    }
    return false;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sign-Up Controller
// ─────────────────────────────────────────────────────────────────────────────
final signUpControllerProvider =
    AsyncNotifierProvider<SignUpController, bool?>(() => SignUpController());

class SignUpController extends AsyncNotifier<bool?> {
  @override
  FutureOr<bool?> build() => null;

  Future<bool> signUp(SignUpRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUp(request),
    );
    return state.value ?? false;
  }

  Future<void> resendOtp(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).sendOtp(email, OtpType.signUp),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sign-Up OTP Verification Controller
// ─────────────────────────────────────────────────────────────────────────────
final otpControllerProvider =
    AsyncNotifierProvider<OtpController, AuthResponse?>(() => OtpController());

class OtpController extends AsyncNotifier<AuthResponse?> {
  @override
  FutureOr<AuthResponse?> build() => null;

  Future<bool> verify(String email, String otp) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).verifySignUpOtp(
            OtpVerificationRequest(
                email: email, otp: otp, type: OtpType.signUp),
          ),
    );
    if (state.value != null) {
      ref.read(currentUserProvider.notifier).setUser(state.value!);
      return true;
    }
    return false;
  }

  Future<void> resendOtp(String email) async {
    await ref.read(authRepositoryProvider).sendOtp(email, OtpType.signUp);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Forgot-Password Controller  (3-step: sendOtp → verifyOtp → resetPassword)
// ─────────────────────────────────────────────────────────────────────────────
final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, bool?>(
        () => ForgotPasswordController());

class ForgotPasswordController extends AsyncNotifier<bool?> {
  @override
  FutureOr<bool?> build() => null;

  Future<bool> sendOtp(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .sendOtp(email, OtpType.forgotPassword),
    );
    return state.value ?? false;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).verifyForgotPasswordOtp(
            OtpVerificationRequest(
                email: email, otp: otp, type: OtpType.forgotPassword),
          ),
    );
    return state.value ?? false;
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).resetPassword(
            ResetPasswordRequest(
                email: email, otp: otp, newPassword: newPassword),
          ),
    );
    return state.value ?? false;
  }

  Future<void> resendOtp(String email) async {
    await ref
        .read(authRepositoryProvider)
        .sendOtp(email, OtpType.forgotPassword);
  }
}

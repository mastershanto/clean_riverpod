import 'dart:async';
import 'package:clean_riverpod/features/auth/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/auth_entities.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sign-In Controller
// ─────────────────────────────────────────────────────────────────────────────
final signInControllerProvider =
    AsyncNotifierProvider<SignInController, AuthUser?>(
        () => SignInController());

class SignInController extends AsyncNotifier<AuthUser?> {
  @override
  FutureOr<AuthUser?> build() => null;

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

  Future<bool> signUp(SignUpParams params) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUp(params),
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
    AsyncNotifierProvider<OtpController, AuthUser?>(() => OtpController());

class OtpController extends AsyncNotifier<AuthUser?> {
  @override
  FutureOr<AuthUser?> build() => null;

  Future<bool> verify(String email, String otp) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).verifySignUpOtp(
            OtpVerificationParams(email: email, otp: otp),
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
            OtpVerificationParams(email: email, otp: otp),
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
            ResetPasswordParams(
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

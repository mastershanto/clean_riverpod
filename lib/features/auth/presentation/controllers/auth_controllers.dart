import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_entities.dart';
import '../../providers/auth_providers.dart';

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, AuthUser?>(() => LoginController());

class LoginController extends AsyncNotifier<AuthUser?> {
  @override
  FutureOr<AuthUser?> build() => null;

  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      final user =
          await ref.read(authRepositoryProvider).signIn(email, password);
      if (user != null) {
        ref.read(currentUserProvider.notifier).setUser(user);
        success = true;
      }
      return user;
    });
    return success;
  }
}

final signUpControllerProvider =
    AsyncNotifierProvider<SignUpController, bool>(() => SignUpController());

class SignUpController extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<bool> signUp(SignUpParams params) async {
    state = const AsyncLoading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      final res = await ref.read(authRepositoryProvider).signUp(params);
      success = res;
      return res;
    });
    return success;
  }

  Future<bool> sendOtp(String email) async {
    state = const AsyncLoading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      final res =
          await ref.read(authRepositoryProvider).sendOtp(email, OtpType.signUp);
      success = res;
      return state.value ?? false;
    });
    return success;
  }
}

final otpControllerProvider =
    AsyncNotifierProvider<OtpController, AuthUser?>(() => OtpController());

class OtpController extends AsyncNotifier<AuthUser?> {
  @override
  FutureOr<AuthUser?> build() => null;

  Future<bool> verifyOtp(String email, String otp) async {
    state = const AsyncLoading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).verifySignUpOtp(
            OtpVerificationParams(email: email, otp: otp),
          );
      if (user != null) {
        ref.read(currentUserProvider.notifier).setUser(user);
        success = true;
      }
      return user;
    });
    return success;
  }
}

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, bool>(
        () => ForgotPasswordController());

class ForgotPasswordController extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<bool> sendOtp(String email) async {
    state = const AsyncLoading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      final res = await ref
          .read(authRepositoryProvider)
          .sendOtp(email, OtpType.forgotPassword);
      success = res;
      return res;
    });
    return success;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    state = const AsyncLoading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      final res =
          await ref.read(authRepositoryProvider).verifyForgotPasswordOtp(
                OtpVerificationParams(email: email, otp: otp),
              );
      success = res;
      return res;
    });
    return success;
  }

  Future<bool> resetPassword(ResetPasswordParams params) async {
    state = const AsyncLoading();
    bool success = false;
    state = await AsyncValue.guard(() async {
      final res = await ref.read(authRepositoryProvider).resetPassword(params);
      success = res;
      return res;
    });
    return success;
  }
}

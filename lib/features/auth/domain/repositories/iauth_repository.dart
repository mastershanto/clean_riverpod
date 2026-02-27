import '../entities/auth_entities.dart';

abstract class IAuthRepository {
  Future<AuthUser?> signIn(String email, String password);
  Future<bool> signUp(SignUpParams params);
  Future<bool> sendOtp(String email, OtpType type);
  Future<bool> resendSignUpOtp(String email);
  Future<AuthUser?> verifySignUpOtp(OtpVerificationParams params);
  Future<bool> verifyForgotPasswordOtp(OtpVerificationParams params);
  Future<bool> resetPassword(ResetPasswordParams params);
  Future<void> logout();
}

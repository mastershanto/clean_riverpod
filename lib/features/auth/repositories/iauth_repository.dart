import 'package:clean_riverpod/features/auth/models/auth_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Abstract Interface - Pure contract for authentication
// ─────────────────────────────────────────────────────────────────────────────
abstract class IAuthRepository {
  /// Sign in with email and password
  /// Returns [AuthResponse] on success, null if credentials invalid
  Future<AuthResponse?> signIn(String email, String password);

  /// Register a new user account
  /// Triggers OTP verification flow
  Future<bool> signUp(SignUpRequest request);

  /// Send OTP to email for the specified flow type
  Future<bool> sendOtp(String email, OtpType type);

  /// Resend OTP for sign-up flow
  Future<bool> resendSignUpOtp(String email);

  /// Verify OTP and complete sign-up registration
  /// Returns auth response with access token
  Future<AuthResponse?> verifySignUpOtp(OtpVerificationRequest request);

  /// Verify OTP for password reset flow
  /// Must be followed by [resetPassword]
  Future<bool> verifyForgotPasswordOtp(OtpVerificationRequest request);

  /// Reset password after OTP verification
  Future<bool> resetPassword(ResetPasswordRequest request);

  /// Logout and clear session
  Future<void> logout();
}

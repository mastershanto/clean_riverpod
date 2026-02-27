/// Enum to distinguish which flow triggered OTP
enum OtpType { signUp, forgotPassword }

/// Request model for sign-up
class SignUpRequest {
  final String name;
  final String email;
  final String password;
  final String phone;

  const SignUpRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}

/// Request model for OTP verification
class OtpVerificationRequest {
  final String email;
  final String otp;
  final OtpType type;

  const OtpVerificationRequest({
    required this.email,
    required this.otp,
    required this.type,
  });
}

/// Request model for resetting a password
class ResetPasswordRequest {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
}

/// Response returned after a successful sign-in or sign-up verification.
/// Replace fields with real token / profile data when the API is ready.
class AuthResponse {
  final String userId;
  final String name;
  final String email;
  final String phone;

  /// JWT or session token — leave empty until real API is wired up.
  final String accessToken;

  const AuthResponse({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.accessToken = '',
  });
}

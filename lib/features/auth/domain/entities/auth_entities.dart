enum OtpType { signUp, forgotPassword }

class AuthUser {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String accessToken;

  const AuthUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.accessToken,
  });
}

class SignUpParams {
  final String name;
  final String email;
  final String password;
  final String phone;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}

class OtpVerificationParams {
  final String email;
  final String otp;

  const OtpVerificationParams({
    required this.email,
    required this.otp,
  });
}

class ResetPasswordParams {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordParams({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
}

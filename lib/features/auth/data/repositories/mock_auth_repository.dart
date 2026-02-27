import 'dart:developer';
import '../../domain/entities/auth_entities.dart';
import '../../domain/repositories/iauth_repository.dart';
import '../models/auth_user_model.dart';

class MockAuthRepository implements IAuthRepository {
  final Map<String, _MockUser> _users = {
    'test@test.com': _MockUser(
      userId: 'u_001',
      name: 'Test User',
      email: 'test@test.com',
      phone: '+1234567890',
      password: '123456',
    ),
  };

  final Map<String, String> _otpStore = {};
  static const _mockOtp = '123456';
  static const _mockDelay = Duration(milliseconds: 800);

  AuthUserModel _toModel(_MockUser user) => AuthUserModel(
        userId: user.userId,
        name: user.name,
        email: user.email,
        phone: user.phone,
        accessToken:
            'mock_token_${user.userId}_${DateTime.now().millisecondsSinceEpoch}',
      );

  @override
  Future<AuthUser?> signIn(String email, String password) async {
    await Future.delayed(_mockDelay);
    final user = _users[email];
    if (user == null || user.password != password) return null;
    return _toModel(user);
  }

  @override
  Future<bool> signUp(SignUpParams params) async {
    await Future.delayed(_mockDelay);
    if (_users.containsKey(params.email))
      throw Exception('Email already registered');
    _users[params.email] = _MockUser(
      userId: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
    );
    await sendOtp(params.email, OtpType.signUp);
    return true;
  }

  @override
  Future<bool> sendOtp(String email, OtpType type) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _otpStore[email] = _mockOtp;
    log('🔑 [MOCK OTP] email=$email | flow=${type.name} | otp=$_mockOtp',
        name: 'MockAuth');
    return true;
  }

  @override
  Future<bool> resendSignUpOtp(String email) async {
    return sendOtp(email, OtpType.signUp);
  }

  @override
  Future<AuthUser?> verifySignUpOtp(OtpVerificationParams params) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (_otpStore[params.email] != params.otp) throw Exception('Invalid OTP');
    _otpStore.remove(params.email);
    final user = _users[params.email];
    if (user == null) throw Exception('User not found');
    return _toModel(user);
  }

  @override
  Future<bool> verifyForgotPasswordOtp(OtpVerificationParams params) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _otpStore[params.email] == params.otp;
  }

  @override
  Future<bool> resetPassword(ResetPasswordParams params) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (_otpStore[params.email] != params.otp) throw Exception('Invalid OTP');
    _otpStore.remove(params.email);
    final user = _users[params.email];
    if (user == null) throw Exception('Email not found');
    _users[params.email] = _MockUser(
      userId: user.userId,
      name: user.name,
      email: user.email,
      phone: user.phone,
      password: params.newPassword,
    );
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

class _MockUser {
  final String userId, name, email, phone, password;
  _MockUser(
      {required this.userId,
      required this.name,
      required this.email,
      required this.phone,
      required this.password});
}

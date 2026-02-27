import 'dart:developer';

import 'package:clean_riverpod/features/auth/models/auth_models.dart';
import 'package:clean_riverpod/features/auth/repositories/iauth_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mock Implementation - For development & testing
// ─────────────────────────────────────────────────────────────────────────────
class MockAuthRepository implements IAuthRepository {
  /// In-memory user store. Pre-seeded with test accounts.
  final Map<String, _MockUser> _users = {
    'test@test.com': _MockUser(
      userId: 'u_001',
      name: 'Test User',
      email: 'test@test.com',
      phone: '+1234567890',
      password: '123456',
    ),
    'demo@demo.com': _MockUser(
      userId: 'u_002',
      name: 'Demo User',
      email: 'demo@demo.com',
      phone: '+0987654321',
      password: 'password123',
    ),
  };

  /// One-time OTP store: email → otp
  final Map<String, String> _otpStore = {};

  static const _mockOtp = '123456';
  static const _mockDelay = Duration(milliseconds: 800);

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Generate mock JWT token
  String _newToken(String userId) =>
      'mock_token_${userId}_${DateTime.now().millisecondsSinceEpoch}';

  /// Convert internal user to AuthResponse
  AuthResponse _toResponse(_MockUser user) => AuthResponse(
        userId: user.userId,
        name: user.name,
        email: user.email,
        phone: user.phone,
        accessToken: _newToken(user.userId),
      );

  // ── IAuthRepository Implementation ────────────────────────────────────────

  @override
  Future<AuthResponse?> signIn(String email, String password) async {
    await Future.delayed(_mockDelay);
    log(
      '📱 Sign-in attempt: $email',
      name: 'MockAuthRepository',
    );

    final user = _users[email];
    if (user == null || user.password != password) {
      log(
        '❌ Sign-in failed: Invalid credentials',
        name: 'MockAuthRepository',
      );
      return null;
    }

    final response = _toResponse(user);
    log(
      '✅ Sign-in successful: ${user.name}',
      name: 'MockAuthRepository',
    );
    return response;
  }

  @override
  Future<bool> signUp(SignUpRequest request) async {
    await Future.delayed(_mockDelay);
    log(
      '📝 Sign-up attempt: ${request.email}',
      name: 'MockAuthRepository',
    );

    if (_users.containsKey(request.email)) {
      log(
        '❌ Sign-up failed: Email already registered',
        name: 'MockAuthRepository',
      );
      throw Exception('Email already registered');
    }

    _users[request.email] = _MockUser(
      userId: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: request.name,
      email: request.email,
      phone: request.phone,
      password: request.password,
    );

    log(
      '✅ User created: ${request.email}',
      name: 'MockAuthRepository',
    );

    // Send OTP for sign-up verification
    await sendOtp(request.email, OtpType.signUp);
    return true;
  }

  @override
  Future<bool> sendOtp(String email, OtpType type) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _otpStore[email] = _mockOtp;

    log(
      '🔑 [MOCK OTP] email=$email | flow=${type.name} | otp=$_mockOtp',
      name: 'MockAuthRepository',
    );

    return true;
  }

  @override
  Future<bool> resendSignUpOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_users.containsKey(email)) {
      log(
        '❌ Resend OTP failed: User not found',
        name: 'MockAuthRepository',
      );
      throw Exception('User not found');
    }

    _otpStore[email] = _mockOtp;
    log(
      '🔄 [MOCK OTP RESENT] email=$email | otp=$_mockOtp',
      name: 'MockAuthRepository',
    );
    return true;
  }

  @override
  Future<AuthResponse?> verifySignUpOtp(OtpVerificationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 600));
    log(
      '🔍 Verifying sign-up OTP: ${request.email}',
      name: 'MockAuthRepository',
    );

    if (_otpStore[request.email] != request.otp) {
      log(
        '❌ OTP verification failed: Invalid OTP',
        name: 'MockAuthRepository',
      );
      throw Exception('Invalid OTP');
    }

    _otpStore.remove(request.email);
    final user = _users[request.email];

    if (user == null) {
      log(
        '❌ OTP verification failed: User not found',
        name: 'MockAuthRepository',
      );
      throw Exception('User not found');
    }

    log(
      '✅ OTP verified: ${user.email}',
      name: 'MockAuthRepository',
    );

    return _toResponse(user);
  }

  @override
  Future<bool> verifyForgotPasswordOtp(OtpVerificationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 600));
    log(
      '🔍 Verifying forgot-password OTP: ${request.email}',
      name: 'MockAuthRepository',
    );

    if (_otpStore[request.email] != request.otp) {
      log(
        '❌ OTP verification failed: Invalid OTP',
        name: 'MockAuthRepository',
      );
      throw Exception('Invalid OTP');
    }

    log(
      '✅ Forgot-password OTP verified',
      name: 'MockAuthRepository',
    );

    // Keep OTP in store so resetPassword can also verify it
    return true;
  }

  @override
  Future<bool> resetPassword(ResetPasswordRequest request) async {
    await Future.delayed(const Duration(milliseconds: 600));
    log(
      '🔄 Resetting password: ${request.email}',
      name: 'MockAuthRepository',
    );

    if (_otpStore[request.email] != request.otp) {
      log(
        '❌ Reset failed: Invalid OTP',
        name: 'MockAuthRepository',
      );
      throw Exception('Invalid OTP');
    }

    _otpStore.remove(request.email);
    final user = _users[request.email];

    if (user == null) {
      log(
        '❌ Reset failed: Email not found',
        name: 'MockAuthRepository',
      );
      throw Exception('Email not found');
    }

    // Update password
    _users[request.email] = _MockUser(
      userId: user.userId,
      name: user.name,
      email: user.email,
      phone: user.phone,
      password: request.newPassword,
    );

    log(
      '✅ Password reset successful: ${user.email}',
      name: 'MockAuthRepository',
    );

    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    log(
      '👋 User logged out',
      name: 'MockAuthRepository',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal Model - For mock storage only
// ─────────────────────────────────────────────────────────────────────────────
class _MockUser {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String password;

  const _MockUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
}

import 'dart:developer';

import 'package:clean_riverpod/features/auth/models/auth_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Interface  (swap MockAuthRepository for a real one when the API is ready)
// ─────────────────────────────────────────────────────────────────────────────
abstract class IAuthRepository {
  Future<AuthResponse?> signIn(String email, String password);
  Future<bool> signUp(SignUpRequest request);
  Future<bool> sendOtp(String email, OtpType type);
  Future<AuthResponse?> verifySignUpOtp(OtpVerificationRequest request);
  Future<bool> verifyForgotPasswordOtp(OtpVerificationRequest request);
  Future<bool> resetPassword(ResetPasswordRequest request);
  Future<void> logout();
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock Implementation  (delete / replace with real impl when ready)
// ─────────────────────────────────────────────────────────────────────────────
class MockAuthRepository implements IAuthRepository {
  /// In-memory user store.  Pre-seeded with one test account.
  final Map<String, _User> _users = {
    'test@test.com': _User(
      userId: 'u_001',
      name: 'Test User',
      email: 'test@test.com',
      phone: '+1234567890',
      password: '123456',
    ),
  };

  /// One-time OTP store: email → otp
  final Map<String, String> _otpStore = {};

  static const _mockOtp = '123456';

  // ── helpers ──────────────────────────────────────────────────────────────
  String _newToken(String userId) =>
      'mock_token_${userId}_${DateTime.now().millisecondsSinceEpoch}';

  AuthResponse _toResponse(_User u) => AuthResponse(
        userId: u.userId,
        name: u.name,
        email: u.email,
        phone: u.phone,
        accessToken: _newToken(u.userId),
      );

  // ── IAuthRepository ───────────────────────────────────────────────────────

  @override
  Future<AuthResponse?> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final user = _users[email];
    if (user == null || user.password != password) return null;
    return _toResponse(user);
  }

  @override
  Future<bool> signUp(SignUpRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (_users.containsKey(request.email)) {
      throw Exception('Email already registered');
    }
    _users[request.email] = _User(
      userId: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: request.name,
      email: request.email,
      phone: request.phone,
      password: request.password,
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
      '🔑 [MOCK OTP] email=$email  flow=${type.name}  otp=$_mockOtp',
      name: 'AuthRepository',
    );
    return true;
  }

  @override
  Future<AuthResponse?> verifySignUpOtp(OtpVerificationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (_otpStore[request.email] != request.otp) {
      throw Exception('Invalid OTP');
    }
    _otpStore.remove(request.email);
    final user = _users[request.email];
    if (user == null) throw Exception('User not found');
    return _toResponse(user);
  }

  @override
  Future<bool> verifyForgotPasswordOtp(OtpVerificationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (_otpStore[request.email] != request.otp) {
      throw Exception('Invalid OTP');
    }
    return true; // otp stays in store so resetPassword can also verify
  }

  @override
  Future<bool> resetPassword(ResetPasswordRequest request) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (_otpStore[request.email] != request.otp) {
      throw Exception('Invalid OTP');
    }
    _otpStore.remove(request.email);
    final user = _users[request.email];
    if (user == null) throw Exception('Email not found');
    _users[request.email] = _User(
      userId: user.userId,
      name: user.name,
      email: user.email,
      phone: user.phone,
      password: request.newPassword,
    );
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal model  (not exported — API consumers use AuthResponse)
// ─────────────────────────────────────────────────────────────────────────────
class _User {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String password;

  const _User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────
final authRepositoryProvider =
    Provider<IAuthRepository>((ref) => MockAuthRepository());

import 'package:clean_riverpod/features/auth/models/auth_models.dart';
import 'package:clean_riverpod/features/auth/repositories/iauth_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Real API Implementation - Connect to actual backend
// ─────────────────────────────────────────────────────────────────────────────
class RealAuthRepository implements IAuthRepository {
  // TODO: Inject your HTTP client (e.g., dio, http package)
  // final HttpClient _httpClient;
  // final String _baseUrl;

  // RealAuthRepository({
  //   required HttpClient httpClient,
  //   required String baseUrl,
  // })  : _httpClient = httpClient,
  //       _baseUrl = baseUrl;

  @override
  Future<AuthResponse?> signIn(String email, String password) async {
    // TODO: Implement real API call
    // Example:
    // final response = await _httpClient.post(
    //   '$_baseUrl/auth/sign-in',
    //   data: {'email': email, 'password': password},
    // );
    // if (response.statusCode == 200) {
    //   return AuthResponse.fromJson(response.data);
    // }
    // return null;

    throw UnimplementedError(
      'Real API not implemented. Connect your backend endpoint.',
    );
  }

  @override
  Future<bool> signUp(SignUpRequest request) async {
    // TODO: Implement real API call
    // Example:
    // final response = await _httpClient.post(
    //   '$_baseUrl/auth/sign-up',
    //   data: request.toJson(),
    // );
    // return response.statusCode == 201;

    throw UnimplementedError(
      'Real API not implemented. Connect your backend endpoint.',
    );
  }

  @override
  Future<bool> sendOtp(String email, OtpType type) async {
    // TODO: Implement real API call
    // Example:
    // final response = await _httpClient.post(
    //   '$_baseUrl/auth/send-otp',
    //   data: {'email': email, 'type': type.name},
    // );
    // return response.statusCode == 200;

    throw UnimplementedError(
      'Real API not implemented. Connect your backend endpoint.',
    );
  }

  @override
  Future<bool> resendSignUpOtp(String email) async {
    // TODO: Implement real API call
    // Example:
    // final response = await _httpClient.post(
    //   '$_baseUrl/auth/resend-signup-otp',
    //   data: {'email': email},
    // );
    // return response.statusCode == 200;

    throw UnimplementedError(
      'Real API not implemented. Connect your backend endpoint.',
    );
  }

  @override
  Future<AuthResponse?> verifySignUpOtp(OtpVerificationRequest request) async {
    // TODO: Implement real API call
    // Example:
    // final response = await _httpClient.post(
    //   '$_baseUrl/auth/verify-signup-otp',
    //   data: request.toJson(),
    // );
    // if (response.statusCode == 200) {
    //   return AuthResponse.fromJson(response.data);
    // }
    // return null;

    throw UnimplementedError(
      'Real API not implemented. Connect your backend endpoint.',
    );
  }

  @override
  Future<bool> verifyForgotPasswordOtp(
    OtpVerificationRequest request,
  ) async {
    // TODO: Implement real API call
    // Example:
    // final response = await _httpClient.post(
    //   '$_baseUrl/auth/verify-forgot-password-otp',
    //   data: request.toJson(),
    // );
    // return response.statusCode == 200;

    throw UnimplementedError(
      'Real API not implemented. Connect your backend endpoint.',
    );
  }

  @override
  Future<bool> resetPassword(ResetPasswordRequest request) async {
    // TODO: Implement real API call
    // Example:
    // final response = await _httpClient.post(
    //   '$_baseUrl/auth/reset-password',
    //   data: request.toJson(),
    // );
    // return response.statusCode == 200;

    throw UnimplementedError(
      'Real API not implemented. Connect your backend endpoint.',
    );
  }

  @override
  Future<void> logout() async {
    // TODO: Implement real API call
    // Example:
    // await _httpClient.post('$_baseUrl/auth/logout');

    throw UnimplementedError(
      'Real API not implemented. Connect your backend endpoint.',
    );
  }
}

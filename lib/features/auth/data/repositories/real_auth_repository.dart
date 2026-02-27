import '../../domain/entities/auth_entities.dart';
import '../../domain/repositories/iauth_repository.dart';

class RealAuthRepository implements IAuthRepository {
  // final Dio _dio;
  // RealAuthRepository(this._dio);

  @override
  Future<AuthUser?> signIn(String email, String password) async {
    // TODO: Implement actual API call using Dio or Http
    throw UnimplementedError();
  }

  @override
  Future<bool> signUp(SignUpParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> sendOtp(String email, OtpType type) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> resendSignUpOtp(String email) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser?> verifySignUpOtp(OtpVerificationParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> verifyForgotPasswordOtp(OtpVerificationParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> resetPassword(ResetPasswordParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: Clear local tokens and call API
  }
}

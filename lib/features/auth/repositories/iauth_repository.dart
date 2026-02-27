// Interface (চুক্তি)
import 'package:clean_riverpod/features/crud/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IAuthRepository {
  Future<UserModel?> login(String email, String password);
  Future<void> logout();
}

// Actual Implementation (আসল কাজ)
class AuthRepository implements IAuthRepository {
  @override
  Future<UserModel?> login(String email, String password) async {
    // এখানে আপনার API বা Firebase কল হবে। উদাহরণস্বরূপ:
    await Future.delayed(const Duration(seconds: 2)); // ২ সেকেন্ড অপেক্ষা
    if (email == "test@test.com" && password == "123456") {
      return UserModel(
        id: "1",
        name: "Test User",
        email: email,
        phone: "+1234567890",
        address: "123 Main St, City, Country",
      );
    }
    return null;
  }

  @override
  Future<void> logout() async {
    // এখানে logout logic যুক্ত করুন - session clear, cache clear ইত্যাদি
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

// Riverpod Provider for Repository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository();
});

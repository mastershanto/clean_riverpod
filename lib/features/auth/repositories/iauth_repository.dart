// Interface (চুক্তি)
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IAuthRepository {
  Future<bool> login(String email, String password);
}

// Actual Implementation (আসল কাজ)
class AuthRepository implements IAuthRepository {
  @override
  Future<bool> login(String email, String password) async {
    // এখানে আপনার API বা Firebase কল হবে। উদাহরণস্বরূপ:
    await Future.delayed(const Duration(seconds: 2)); // ২ সেকেন্ড অপেক্ষা
    if (email == "test@test.com" && password == "123456") {
      return true;
    }
    return false;
  }
}

// Riverpod Provider for Repository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository();
});
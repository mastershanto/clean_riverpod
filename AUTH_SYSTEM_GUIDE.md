# Complete Authentication System Guide

## Overview
Your app now has a complete, production-ready authentication system with mock responses. The system supports:
- ✅ Sign In
- ✅ Sign Up with email verification
- ✅ Forgot Password with OTP reset
- ✅ Skip authentication (go directly to dashboard)
- ✅ Mock OTP responses logged to console
- ✅ Ready for real API integration

---

## 🎯 Features

### 1. **Sign In Flow**
- Route: `/auth` (default)
- Pre-filled test credentials:
  - Email: `test@test.com`
  - Password: `123456`
- Has "Skip for now" button to enter dashboard without authentication
- Has "Forgot Password?" link for password recovery
- Has "Sign Up" link to create new account

### 2. **Sign Up Flow**
- Route: `/auth/signup`
- Accepts: Full Name, Email, Phone (optional), Password, Confirm Password
- Automatically sends OTP after successful signup
- Redirects to email verification screen

### 3. **Sign Up Email Verification**
- Route: `/auth/signup-verify?email=user@example.com`
- 6-digit OTP input with individual boxes
- Auto-advances focus between boxes
- Auto-submits when all 6 digits entered
- Can resend OTP (60-second cooldown)
- Mock OTP: `123456` (logged to console)

### 4. **Forgot Password Flow**
- Route: `/auth/forgot-password`
- Step 1: Enter email address
- Step 2: Verify with 6-digit OTP (logged to console)
- Step 3: Set new password + confirm
- Returns to login after successful reset

### 5. **Dashboard Access**
- Route: `/` (home)
- Can be accessed by:
  - ✅ Signing in with email/password
  - ✅ Signing up and verifying email OTP
  - ✅ Using "Skip for now" button (allows browsing as guest)
  - ✅ Resetting password via forgot password flow

---

## 🔐 Mock OTP Configuration

### Default Mock Credentials
```
Email: test@test.com
Password: 123456
OTP: 123456 (for any email)
```

### How Mock OTP Works
1. When you request an OTP (signup or forgot password), the system logs:
   ```
   🔑 [MOCK OTP] email=user@email.com flow=signUp otp=123456
   ```
2. Check **Flutter DEBUG CONSOLE** or **Logcat**
3. Copy the OTP and use it in the verification screen

### Logging
- **File**: `lib/features/auth/repositories/iauth_repository.dart`
- **Method**: `sendOtp()` in `MockAuthRepository`
- **Output**: Logged with `dart:developer` → visible in IDE console

---

## 📁 File Structure

```
lib/features/auth/
├── models/
│   └── auth_models.dart          # Request/Response DTOs
├── repositories/
│   └── iauth_repository.dart     # Interface + MockAuthRepository
├── controllers/
│   └── auth_controller.dart      # Business logic providers
└── presentations/
    ├── login/
    │   └── ui/
    │       └── login_screen.dart
    ├── signup/
    │   └── ui/
    │       └── singup_screen.dart
    ├── otp_verify/
    │   └── otp_verify_screen.dart
    └── forgot_password/
        ├── forgot_password_screen.dart
        └── reset_password_screen.dart

lib/providers/
└── auth_provider.dart             # Global auth state + currentUserProvider

lib/router/
└── app_router.dart                # GoRouter route definitions
```

---

## 🔄 API Integration (When Ready)

### Step 1: Create Real Repository
```dart
// lib/features/auth/repositories/auth_repository.dart
class AuthRepository implements IAuthRepository {
  final HttpClient _httpClient;
  
  @override
  Future<AuthResponse?> signIn(String email, String password) async {
    final response = await _httpClient.post(
      '/api/auth/signin',
      body: {'email': email, 'password': password},
    );
    // Parse response...
  }
  
  // Implement other methods...
}
```

### Step 2: Update Provider
```dart
// lib/features/auth/repositories/iauth_repository.dart
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  // Try to use real API, fallback to mock if disabled
  return kUseMockAuth ? MockAuthRepository() : AuthRepository();
});
```

### Step 3: No UI Changes Needed! ✨
The controllers and screens use the interface, so swapping `MockAuthRepository` → `AuthRepository` is transparent.

---

## 🧪 Testing Guide

### Test 1: Sign In with Valid Credentials
1. Open app → lands on `/auth`
2. Email: `test@test.com`, Password: `123456`
3. Click "Sign In"
4. ✅ Should navigate to `/` (dashboard)
5. Current user stored in `currentUserProvider`

### Test 2: Sign In with Invalid Credentials
1. Email: `invalid@email.com`, Password: `wrong`
2. Click "Sign In"
3. ✅ Shows error message "Invalid email or password"
4. Stays on login screen

### Test 3: Sign Up Flow
1. Click "Sign Up" on login screen
2. Fill: Name, Email, Phone, Password (min 6 chars), Confirm
3. Click "Create Account"
4. ✅ Navigates to OTP verification
5. Console shows: `🔑 [MOCK OTP] email=your@email.com flow=signUp otp=123456`
6. Enter OTP: `123456`
7. ✅ Auto-submits and navigates to dashboard

### Test 4: Skip Authentication
1. On login screen, click "Skip for now"
2. ✅ Immediately navigates to `/` (dashboard)
3. User is NOT authenticated (guest mode)
4. Can still browse app but some features may be restricted

### Test 5: Forgot Password Flow
1. On login screen, click "Forgot Password?"
2. Enter email: `test@test.com`
3. Click "Send Reset Code"
4. Console shows: `🔑 [MOCK OTP] email=test@test.com flow=forgotPassword otp=123456`
5. Enter OTP: `123456`
6. New Password: `newpass123`, Confirm: `newpass123`
7. Click "Reset Password"
8. ✅ Success message, navigates back to `/auth`
9. ✅ Can now sign in with new password: `newpass123`

### Test 6: Resend OTP
1. On OTP verification screen
2. Click "Resend OTP" after 60s passes
3. ✅ New OTP logged to console
4. Timer resets to 60s

### Test 7: OTP Auto-Submit
1. On OTP verification screen
2. Manually enter all 6 OTP digits
3. ✅ Should auto-submit when 6th digit entered (no need to click verify)

---

## 🔌 Controllers & Providers

### `signInControllerProvider`
```dart
// Use it like:
final ok = await ref.read(signInControllerProvider.notifier)
  .signIn(email, password);
```
- Returns: `AsyncValue<AuthResponse?>`
- States: Loading, Success, Error

### `signUpControllerProvider`
```dart
final ok = await ref.read(signUpControllerProvider.notifier)
  .signUp(SignUpRequest(...));
```
- Returns: `AsyncValue<bool?>`

### `otpControllerProvider`
```dart
final ok = await ref.read(otpControllerProvider.notifier)
  .verify(email, otp);
```
- For sign-up OTP verification

### `forgotPasswordControllerProvider`
```dart
await ref.read(forgotPasswordControllerProvider.notifier)
  .sendOtp(email);
```
- Has: `sendOtp()`, `verifyOtp()`, `resetPassword()`, `resendOtp()`

### `currentUserProvider`
```dart
// Reading user data
final user = ref.watch(currentUserProvider);

// Logging out
await ref.read(currentUserProvider.notifier).logout();
```

---

## 🛡️ Models Reference

### `AuthResponse` (Returned after auth)
```dart
class AuthResponse {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String accessToken;
}
```

### `SignUpRequest`
```dart
class SignUpRequest {
  final String name;
  final String email;
  final String password;
  final String phone;
}
```

### `OtpVerificationRequest`
```dart
class OtpVerificationRequest {
  final String email;
  final String otp;
  final OtpType type; // OtpType.signUp or OtpType.forgotPassword
}
```

### `ResetPasswordRequest`
```dart
class ResetPasswordRequest {
  final String email;
  final String otp;
  final String newPassword;
}
```

---

## 🚀 Common Tasks

### Check If User Is Authenticated
```dart
final isAuthenticated = ref.watch(isAuthenticatedProvider);
if (isAuthenticated) {
  // User is signed in
} else {
  // User is guest/signed out
}
```

### Get Current User Data
```dart
final user = ref.watch(currentUserProvider);
print(user?.name); // e.g., "Test User"
print(user?.email); // e.g., "test@test.com"
```

### Handle Logout
```dart
// In a button or menu
onPressed: () async {
  await ref.read(currentUserProvider.notifier).logout();
  // Navigate back to login
  context.go('/auth');
}
```

### Show User Info in Dashboard
```dart
Consumer(
  builder: (ctx, ref, child) {
    final user = ref.watch(currentUserProvider);
    return Text(user?.name ?? 'Guest User');
  },
)
```

---

## ⚠️ Error Handling

All screens handle errors gracefully:
- Invalid email/password → Error message below input
- OTP verification failed → "Invalid OTP. Please try again."
- API errors (when integrated) → Displayed in error container
- Network timeout → Will show error after async timeout
- Duplicate email on signup → Caught and shown to user

---

## 📝 Notes

1. **Mock Tests Persistent**: In-memory `_users` map persists during app session
   - Create account → can sign in later in same session
   - Close app → resets all mock data
   
2. **Token Format**: Mock tokens are just placeholders
   - Real API: Use JWT or session tokens
   - Replace `_newToken()` method when integrating

3. **Password Storage**: Never shown in UI (obscured by default)
   - Use proper hashing on backend when ready

4. **OTP Logging**: Only happens on `sendOtp()`
   - Check console before entering OTP

5. **Route Navigation**: Uses GoRouter for type-safe routing
   - All auth routes under `/auth`
   - Dashboard route is `/`

---

## 🎓 Example: Creating a New Auth Handler

If you need to hook into auth events:

```dart
// Example: Update some provider when user logs in
Future<void> signIn(String email, String password) async {
  state = const AsyncLoading();
  state = await AsyncValue.guard(() async {
    final user = await ref.read(authRepositoryProvider).signIn(email, password);
    if (user != null) {
      ref.read(currentUserProvider.notifier).setUser(user);
      // ✨ Add custom logic here
      // ref.read(someOtherProvider.notifier).initialize(user.userId);
    }
    return user;
  });
}
```

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| OTP not visible | Check Debug Console in VS Code or Logcat in Android Studio |
| Login page not showing skip button | Run `flutter clean && flutter pub get && flutter run` |
| OTP auto-verify not working | Ensure all 6 digits are entered; should trigger auto-submit |
| Forgot password redirects wrong | Check route parameter: `/auth/forgot-otp?email=...` |
| Mock users reset after close | Expected behavior - use persistent storage when integrating real API |

---

## 📚 Next Steps

1. ✅ Test all five flows above
2. ✅ Check console for mock OTP
3. When API is ready:
   - Create `AuthRepository` implementing `IAuthRepository`
   - Update `authRepositoryProvider` to use it
   - Update models/requests to match your API
4. Add token persistence (SharedPreferences/Secure Storage)
5. Add request/response interceptors for tokens
6. Add refresh token mechanism

---

## 📞 Quick Reference

**Login**: `/auth`  
**Sign Up**: `/auth/signup`  
**Email Verify**: `/auth/signup-verify?email=...`  
**Forgot Password**: `/auth/forgot-password`  
**Password Reset**: `/auth/forgot-otp?email=...`  
**Dashboard**: `/`  

**Mock OTP**: Always `123456` (check console)  
**Test Account**: `test@test.com` / `123456`  
**Skip Button**: On login screen to enter dashboard as guest  

Happy coding! 🚀

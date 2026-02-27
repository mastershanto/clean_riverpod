import '../../domain/entities/auth_entities.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.userId,
    required super.name,
    required super.email,
    required super.phone,
    required super.accessToken,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      userId: json['user_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      accessToken: json['access_token'] ?? json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'access_token': accessToken,
    };
  }
}

import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  /// Factory constructor to create a [UserModel] from a JSON object.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  /// Helper to convert a [UserModel] into a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  /// Convert UserModel to UserEntity (domain layer)
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
    );
  }

  /// Create UserModel from UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
    );
  }

  /// Factory to create from Drift User (from local database)
  factory UserModel.fromDriftUser(User driftUser) {
    return UserModel(
      id: driftUser.id,
      name: driftUser.name,
      email: driftUser.email,
      phone: driftUser.phone,
      address: driftUser.address,
    );
  }

  /// Convert to Drift User for database operations
  User toDriftUser() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
    );
  }

  /// Convert to Drift UsersCompanion for insertions
  UsersCompanion toCompanion() {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      phone: Value(phone),
      address: Value(address),
    );
  }
}

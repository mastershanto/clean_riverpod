class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  // Adding copyWith for convenience
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}

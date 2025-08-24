enum UserRole { admin, vendor, customer }

class User {
  final String id;
  final String username;
  final String email;
  final String name;
  final UserRole role;
  final String? avatarUrl;
  final String? phone;
  final String? bio;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    this.role = UserRole.customer,
    this.avatarUrl,
    this.phone,
    this.bio,
  });

  User copyWith({
    String? username,
    String? email,
    String? name,
    UserRole? role,
    String? avatarUrl,
    String? phone,
    String? bio,
  }) =>
      User(
        id: id,
        username: username ?? this.username,
        email: email ?? this.email,
        name: name ?? this.name,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        phone: phone ?? this.phone,
        bio: bio ?? this.bio,
      );
}

import 'package:yominero/shared/models/user.dart';

/// Very small in-memory auth / user management mock.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  User? _current;
  User? get currentUser => _current;
  bool get isLoggedIn => _current != null;

  Future<User> login({required String email, required String password}) async {
    // Mock: derive username & role.
    final role = email.contains('admin')
        ? UserRole.admin
        : email.contains('vendor')
            ? UserRole.vendor
            : UserRole.customer;
    _current = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: email.split('@').first,
      email: email,
      name: 'Usuario ${role.name}',
      role: role,
      bio: 'Bio de ejemplo para ${role.name}',
    );
    return _current!;
  }

  void logout() => _current = null;
}

/// Simple role guard util.
bool userHasRole(UserRole requiredRole) {
  final u = AuthService.instance.currentUser;
  if (u == null) return false;
  if (requiredRole == UserRole.admin) return u.role == UserRole.admin;
  if (requiredRole == UserRole.vendor) {
    return u.role == UserRole.vendor ||
        u.role == UserRole.admin; // admin overrides
  }
  return true; // customer required
}

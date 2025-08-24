import 'package:yominero/shared/models/user.dart';
import 'package:yominero/shared/models/post.dart';

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
    // Provide richer mock data to fuel matching engine.
    const baseTags = ['taladro', 'mantenimiento', 'drone', 'mapeo'];
    final services = <ServiceOffering>[
      const ServiceOffering(
        name: 'Mantenimiento de equipo',
        category: 'Maquinaria',
        tags: ['taladro', 'mantenimiento'],
        pricing: PricingRange(from: 50, to: 120, unit: 'hora'),
      ),
      if (role != UserRole.customer)
        const ServiceOffering(
          name: 'Topografía avanzada',
          category: 'Topografía',
          tags: ['topografía', 'mapeo', 'drone'],
          pricing: PricingRange(from: 500, to: 2000, unit: 'proyecto'),
        ),
    ];
    _current = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: email.split('@').first,
        email: email,
        name: 'Usuario ${role.name}',
        role: role,
        bio: 'Bio de ejemplo para ${role.name}',
        servicesOffered: services,
        interests: baseTags.sublist(2),
        watchKeywords: const ['mapeo', 'drone'],
        ratingAvg: 4.6,
        ratingCount: 23,
        completedJobsCount: 41);
    return _current!;
  }

  void logout() => _current = null;

  // --- Preference update helpers (in-memory only) ---
  User? updateUser(User Function(User current) updater) {
    final cur = _current;
    if (cur == null) return null;
    final updated = updater(cur);
    _current = updated;
    return updated;
  }

  User? togglePreferredPostType(PostType type) {
    return updateUser((u) {
      final set = u.preferredPostTypes.toSet();
      if (set.contains(type)) {
        set.remove(type);
        if (set.isEmpty) {
          // Always keep at least community visible
          set.add(PostType.community);
        }
      } else {
        set.add(type);
      }
      return u.copyWith(preferredPostTypes: set);
    });
  }

  User? followTag(String tag) {
    tag = tag.toLowerCase();
    return updateUser((u) {
      if (u.followedTags.contains(tag)) return u;
      return u.copyWith(followedTags: [...u.followedTags, tag]);
    });
  }

  User? unfollowTag(String tag) {
    tag = tag.toLowerCase();
    return updateUser((u) => u.copyWith(
        followedTags: u.followedTags.where((t) => t != tag).toList()));
  }

  User? followCategory(String cat) {
    cat = cat.toLowerCase();
    return updateUser((u) {
      if (u.followedCategories.contains(cat)) return u;
      return u.copyWith(followedCategories: [...u.followedCategories, cat]);
    });
  }

  User? unfollowCategory(String cat) {
    cat = cat.toLowerCase();
    return updateUser((u) => u.copyWith(
        followedCategories:
            u.followedCategories.where((c) => c != cat).toList()));
  }
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

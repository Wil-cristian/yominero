import 'package:flutter/material.dart';
import 'package:yominero/shared/models/user.dart';
import 'core/auth/auth_service.dart';
import 'main.dart';
import 'core/theme/colors.dart';

/// Home / onboarding screen allowing selecting one of predefined profiles.
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<User> demoProfiles = const [
    User(
        id: 'u1',
        username: 'admin',
        email: 'admin@example.com',
        name: 'Admin',
        role: UserRole.admin,
        bio: 'Control total del sistema'),
    User(
        id: 'u2',
        username: 'vendor_jane',
        email: 'vendor@example.com',
        name: 'Vendedora Jane',
        role: UserRole.vendor,
        bio: 'Gestiona productos y servicios'),
    User(
        id: 'u3',
        username: 'carlos',
        email: 'carlos@cliente.com',
        name: 'Carlos Cliente',
        role: UserRole.customer,
        bio: 'Explora y solicita recursos'),
  ];

  Future<void> _selectProfile(BuildContext context, User user) async {
    // Simula login estableciendo el usuario directamente.
    AuthService.instance
        .login(email: user.email, password: 'x')
        .then((_) => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainApp()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.darken(.3),
              AppColors.primary,
              AppColors.primaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'YoMinero',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona un perfil para continuar',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.separated(
                    itemCount: demoProfiles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final u = demoProfiles[index];
                      return InkWell(
                        onTap: () => _selectProfile(context, u),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  u.username.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Chip(
                                          label: Text(
                                            u.role.name,
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          backgroundColor: AppColors.surface,
                                          side: const BorderSide(
                                            color: AppColors.outline,
                                            width: .8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 0),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            u.bio ?? '',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white70, size: 18),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

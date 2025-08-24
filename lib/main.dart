import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/auth/auth_service.dart';
import 'core/theme/theme.dart';
import 'core/theme/colors.dart';
import 'shared/models/user.dart';
import 'community_page.dart';
import 'products_page.dart';
import 'services_page.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YoMinero App',
      theme: yoMineroTheme,
      onGenerateRoute: onGenerateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const CommunityPage(),
      const ProductsPage(),
      const ServicesPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser ??
        const User(
            id: '0', username: 'guest', email: 'guest@local', name: 'Invitado');
    final pages = [
      ..._pages,
      ProfilePage(user: user, posts: const []),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Comunidad',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Productos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: 'Servicios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

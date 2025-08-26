import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/routing/app_router.dart';
import 'core/di/locator.dart';
import 'core/auth/auth_service.dart';
import 'core/auth/supabase_service.dart';
import 'core/theme/theme.dart';
import 'core/theme/colors.dart';
import 'shared/models/user.dart';
import 'community_page.dart';
import 'products_page.dart';
import 'services_page.dart';
import 'profile_page.dart';
import 'groups_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  setupLocator();

  // Initialize Supabase with a timeout so the app doesn't block on slow networks
  bool supabaseReady = false;
  try {
    await SupabaseService.instance
        .init()
        .timeout(const Duration(seconds: 10));
    supabaseReady = true;
  } on TimeoutException catch (_) {
    // ignore: avoid_print
    print('Supabase initialization timed out. Continuing in offline mode.');
  } catch (e) {
    // ignore: avoid_print
    print('Supabase init error: $e');
  }

  runApp(MyApp(supabaseReady: supabaseReady));
}

class MyApp extends StatelessWidget {
  final bool supabaseReady;
  const MyApp({super.key, required this.supabaseReady});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YoMinero App',
      theme: yoMineroTheme,
      onGenerateRoute: onGenerateRoute,
      initialRoute: supabaseReady ? AppRoutes.home : AppRoutes.home,
      home: supabaseReady ? const MainApp() : const OfflineSplash(),
    );
  }
}

class OfflineSplash extends StatelessWidget {
  const OfflineSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            FlutterLogo(size: 96),
            SizedBox(height: 16),
            Text('No se pudo conectar a Supabase. Modo limitado.'),
          ],
        ),
      ),
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
    _pages = const [
      CommunityPage(),
      GroupsPage(),
      ProductsPage(),
      ServicesPage(),
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
              icon: Icon(Icons.forum),
              label: 'Comunidad',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: 'Grupos',
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

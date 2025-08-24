import 'package:flutter/material.dart';
import '../../home_page.dart';
import '../../main.dart';
import '../../login_page.dart';
import '../../community_page.dart';
import '../../products_page.dart';
import '../../services_page.dart';
import '../../groups_page.dart';
import '../../group_detail_page.dart';
import '../../profile_page.dart';
import '../../post_detail_page.dart';
import '../../product_detail_page.dart';
import '../../service_detail_page.dart';
import '../auth/auth_service.dart';

/// Centralized route names
class AppRoutes {
  static const home = '/home';
  static const login = '/login';
  static const main = '/main';
  static const community = '/community';
  static const products = '/products';
  static const services = '/services';
  static const groups = '/groups';
  static const groupDetail = '/group';
  static const profile = '/profile';
  static const postDetail = '/post';
  static const productDetail = '/product';
  static const serviceDetail = '/service';
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case AppRoutes.main:
      return MaterialPageRoute(builder: (_) => const MainApp());
    case AppRoutes.community:
      return MaterialPageRoute(builder: (_) => const CommunityPage());
    case AppRoutes.products:
      return MaterialPageRoute(builder: (_) => const ProductsPage());
    case AppRoutes.services:
      return MaterialPageRoute(builder: (_) => const ServicesPage());
    case AppRoutes.groups:
      return MaterialPageRoute(builder: (_) => const GroupsPage());
    case AppRoutes.groupDetail:
      if (settings.arguments == null) {
        return _error('Grupo no proporcionado');
      }
      return MaterialPageRoute(
          builder: (_) =>
              GroupDetailPage(group: settings.arguments as dynamic));
    case AppRoutes.profile:
      final user = AuthService.instance.currentUser;
      if (user == null) {
        return MaterialPageRoute(builder: (_) => const HomePage());
      }
      return MaterialPageRoute(
          builder: (_) => ProfilePage(user: user, posts: const []));
    case AppRoutes.postDetail:
      if (settings.arguments == null) {
        return _error('Post no proporcionado');
      }
      return MaterialPageRoute(
          builder: (_) => PostDetailPage(post: settings.arguments as dynamic));
    case AppRoutes.productDetail:
      if (settings.arguments == null) {
        return _error('Producto no proporcionado');
      }
      return MaterialPageRoute(
          builder: (_) =>
              ProductDetailPage(product: settings.arguments as dynamic));
    case AppRoutes.serviceDetail:
      if (settings.arguments == null) {
        return _error('Servicio no proporcionado');
      }
      return MaterialPageRoute(
          builder: (_) =>
              ServiceDetailPage(service: settings.arguments as dynamic));
    default:
      return null;
  }
}

Route<dynamic> _error(String message) => MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error de navegación')),
        body: Center(child: Text(message)),
      ),
    );

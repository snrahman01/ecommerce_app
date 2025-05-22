import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/splash/presentation/pages/splash_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/products/presentation/pages/products_page.dart';
import 'package:ecommerce_app/features/cart/presentation/pages/cart_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String products = '/products';
  static const String cart = '/cart';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case products:
        return MaterialPageRoute(builder: (_) => const ProductsPage());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 
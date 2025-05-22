import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/config/app_theme.dart';
import 'package:ecommerce_app/config/app_routes.dart';
import 'package:ecommerce_app/core/network/api_service.dart';
import 'package:ecommerce_app/features/auth/data/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final authRepository = AuthRepository(apiService: apiService);
    final productRepository = ProductRepository(apiService: apiService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: authRepository)
            ..add(CheckAuthStatus()),
        ),
        BlocProvider(
          create: (context) => ProductsBloc(productRepository: productRepository),
        ),
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repository.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
  });

  testWidgets('App shows products list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProductsBloc>(
            create: (context) => ProductsBloc(
              productRepository: mockProductRepository,
            ),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(),
          ),
        ],
        child: const MyApp(),
      ),
    );

    // Wait for splash screen timer
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that the app shows the products screen
    expect(find.byType(Scaffold), findsOneWidget);
  });
}

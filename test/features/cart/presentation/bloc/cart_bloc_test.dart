import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';

void main() {
  late CartBloc cartBloc;

  setUp(() {
    cartBloc = CartBloc();
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc', () {
    const tProduct = ProductModel(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: 'Test Category',
      images: ['https://test.com/image.jpg'],
      reviews: [Review(rating: 4, comment: 'Great product')],
    );

    test('initial state should be CartInitial', () {
      expect(cartBloc.state, isA<CartInitial>());
    });

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartLoaded] when AddToCart is added',
      build: () => cartBloc,
      act: (bloc) => bloc.add(const AddToCart(product: tProduct)),
      expect: () => [
        isA<CartLoading>(),
        isA<CartLoaded>().having(
          (state) => state.items.length,
          'items length',
          1,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartLoaded] when RemoveFromCart is added',
      build: () => cartBloc,
      seed: () => CartLoaded(
        items: const [CartItem(product: tProduct, quantity: 1)],
        total: tProduct.price,
      ),
      act: (bloc) => bloc.add(const RemoveFromCart(tProduct)),
      expect: () => [
        isA<CartLoading>(),
        isA<CartLoaded>().having(
          (state) => state.items.length,
          'items length',
          0,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartLoaded] when UpdateQuantity is added',
      build: () {
        final bloc = CartBloc();
        bloc.add(const AddToCart(product: tProduct));
        return bloc;
      },
      skip: 2,
      act: (bloc) => bloc.add(const UpdateQuantity(
        product: tProduct,
        quantity: 2,
      )),
      expect: () => [
        isA<CartLoading>(),
        isA<CartLoaded>()
            .having(
              (state) => state.items.first.quantity,
              'item quantity',
              2,
            )
            .having(
              (state) => state.total,
              'total',
              tProduct.price * 2,
            ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartLoaded] when ClearCart is added',
      build: () => cartBloc,
      seed: () => CartLoaded(
        items: const [CartItem(product: tProduct, quantity: 1)],
        total: tProduct.price,
      ),
      act: (bloc) => bloc.add(ClearCart()),
      expect: () => [
        isA<CartLoading>(),
        isA<CartLoaded>().having(
          (state) => state.items.length,
          'items length',
          0,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'updates quantity when adding same product multiple times',
      build: () => cartBloc,
      act: (bloc) => bloc
        ..add(const AddToCart(product: tProduct))
        ..add(const AddToCart(product: tProduct)),
      expect: () => [
        isA<CartLoading>(),
        isA<CartLoaded>().having(
          (state) => state.items.first.quantity,
          'item quantity',
          1,
        ),
        isA<CartLoading>(),
        isA<CartLoaded>().having(
          (state) => state.items.first.quantity,
          'item quantity',
          2,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'removes item when updating quantity to 0',
      build: () => cartBloc,
      seed: () => CartLoaded(
        items: const [CartItem(product: tProduct, quantity: 1)],
        total: tProduct.price,
      ),
      act: (bloc) => bloc.add(const UpdateQuantity(
        product: tProduct,
        quantity: 0,
      )),
      expect: () => [
        isA<CartLoading>(),
        isA<CartLoaded>().having(
          (state) => state.items.length,
          'items length',
          0,
        ),
      ],
    );
  });
} 
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/products_bloc.dart';

import 'products_bloc_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late MockProductRepository mockProductRepository;
  late ProductsBloc productsBloc;

  setUp(() {
    mockProductRepository = MockProductRepository();
    productsBloc = ProductsBloc(productRepository: mockProductRepository);
  });

  tearDown(() {
    productsBloc.close();
  });

  group('ProductsBloc', () {
    final tProduct = ProductModel(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: 'Test Category',
      images: ['https://test.com/image.jpg'],
      reviews: [Review(rating: 4, comment: 'Great product')],
    );

    test('initial state should be ProductsInitial', () {
      expect(productsBloc.state, isA<ProductsInitial>());
    });

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when LoadProducts is added successfully',
      build: () {
        when(mockProductRepository.getProducts())
            .thenAnswer((_) async => [tProduct]);
        return productsBloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>(),
      ],
      verify: (_) {
        verify(mockProductRepository.getProducts());
        verifyNoMoreInteractions(mockProductRepository);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductsError] when LoadProducts fails',
      build: () {
        when(mockProductRepository.getProducts())
            .thenThrow(Exception('Failed to load products'));
        return productsBloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsError>(),
      ],
      verify: (_) {
        verify(mockProductRepository.getProducts());
        verifyNoMoreInteractions(mockProductRepository);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductLoaded] when LoadProductById is added successfully',
      build: () {
        when(mockProductRepository.getProductById(1))
            .thenAnswer((_) async => tProduct);
        return productsBloc;
      },
      act: (bloc) => bloc.add(const LoadProductById(1)),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductLoaded>(),
      ],
      verify: (_) {
        verify(mockProductRepository.getProductById(1));
        verifyNoMoreInteractions(mockProductRepository);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, CategoriesLoaded] when LoadCategories is added successfully',
      build: () {
        when(mockProductRepository.getCategories())
            .thenAnswer((_) async => ['Category 1', 'Category 2']);
        return productsBloc;
      },
      act: (bloc) => bloc.add(LoadCategories()),
      expect: () => [
        isA<ProductsLoading>(),
        isA<CategoriesLoaded>(),
      ],
      verify: (_) {
        verify(mockProductRepository.getCategories());
        verifyNoMoreInteractions(mockProductRepository);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when LoadProductsByCategory is added successfully',
      build: () {
        when(mockProductRepository.getProductsByCategory('test'))
            .thenAnswer((_) async => [tProduct]);
        return productsBloc;
      },
      act: (bloc) => bloc.add(const LoadProductsByCategory('test')),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>(),
      ],
      verify: (_) {
        verify(mockProductRepository.getProductsByCategory('test'));
        verifyNoMoreInteractions(mockProductRepository);
      },
    );
  });
} 
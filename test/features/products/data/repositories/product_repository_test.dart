import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/api_service.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';

import 'product_repository_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late ProductRepository productRepository;

  setUp(() {
    mockApiService = MockApiService();
    productRepository = ProductRepository(apiService: mockApiService);
  });

  group('ProductRepository', () {
    final tProductJson = {
      'id': 1,
      'title': 'Test Product',
      'price': 99.99,
      'description': 'Test Description',
      'category': 'Test Category',
      'images': ['https://test.com/image.jpg'],
      'reviews': [{'rating': 4, 'comment': 'Great product'}]
    };

    final tProduct = ProductModel(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: 'Test Category',
      images: ['https://test.com/image.jpg'],
      reviews: [Review(rating: 4, comment: 'Great product')],
    );

    test('getProducts should return list of products', () async {
      // arrange
      when(mockApiService.get('/products')).thenAnswer(
        (_) async => Response(
          data: {
            'products': [tProductJson]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products'),
        ),
      );

      // act
      final result = await productRepository.getProducts();

      // assert
      expect(result, [tProduct]);
      verify(mockApiService.get('/products'));
      verifyNoMoreInteractions(mockApiService);
    });

    test('getProductById should return a single product', () async {
      // arrange
      when(mockApiService.get('/products/1')).thenAnswer(
        (_) async => Response(
          data: tProductJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products/1'),
        ),
      );

      // act
      final result = await productRepository.getProductById(1);

      // assert
      expect(result, tProduct);
      verify(mockApiService.get('/products/1'));
      verifyNoMoreInteractions(mockApiService);
    });

    test('getCategories should return list of categories', () async {
      // arrange
      final tCategories = ['Category 1', 'Category 2'];
      when(mockApiService.get('/products/categories')).thenAnswer(
        (_) async => Response(
          data: tCategories,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products/categories'),
        ),
      );

      // act
      final result = await productRepository.getCategories();

      // assert
      expect(result, tCategories);
      verify(mockApiService.get('/products/categories'));
      verifyNoMoreInteractions(mockApiService);
    });

    test('getProductsByCategory should return list of products', () async {
      // arrange
      when(mockApiService.get('/products/category/test')).thenAnswer(
        (_) async => Response(
          data: [tProductJson],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products/category/test'),
        ),
      );

      // act
      final result = await productRepository.getProductsByCategory('test');

      // assert
      expect(result, [tProduct]);
      verify(mockApiService.get('/products/category/test'));
      verifyNoMoreInteractions(mockApiService);
    });

    test('should throw exception when API call fails', () async {
      // arrange
      when(mockApiService.get('/products')).thenThrow(Exception('Failed to load products'));

      // act & assert
      expect(
        () => productRepository.getProducts(),
        throwsA(isA<Exception>()),
      );
      verify(mockApiService.get('/products'));
      verifyNoMoreInteractions(mockApiService);
    });
  });
} 
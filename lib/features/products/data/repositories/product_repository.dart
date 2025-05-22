import 'package:ecommerce_app/core/network/api_service.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({required ApiService apiService}) : _apiService = apiService;

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get('/products');
      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'];
        return productsJson
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _apiService.get('/products/$id');
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiService.get('/products/categories');
      return (response.data as List).cast<String>();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _apiService.get('/products/category/$category');
      return (response.data as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
} 
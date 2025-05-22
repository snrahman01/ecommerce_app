import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repository.dart';

// Events
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductsEvent {}

class LoadProductById extends ProductsEvent {
  final int id;

  const LoadProductById(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadCategories extends ProductsEvent {}

class LoadProductsByCategory extends ProductsEvent {
  final String category;

  const LoadProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

// States
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductLoaded extends ProductsState {
  final ProductModel product;

  const ProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class CategoriesLoaded extends ProductsState {
  final List<String> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository _productRepository;

  ProductsBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<LoadCategories>(_onLoadCategories);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final products = await _productRepository.getProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onLoadProductById(
    LoadProductById event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final product = await _productRepository.getProductById(event.id);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final categories = await _productRepository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final products = await _productRepository.getProductsByCategory(event.category);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
} 
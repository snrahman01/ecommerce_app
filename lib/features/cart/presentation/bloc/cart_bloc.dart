import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final ProductModel product;
  final int quantity;

  const AddToCart({
    required this.product,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [product, quantity];
}

class RemoveFromCart extends CartEvent {
  final ProductModel product;

  const RemoveFromCart(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateQuantity extends CartEvent {
  final ProductModel product;
  final int quantity;

  const UpdateQuantity({
    required this.product,
    required this.quantity,
  });

  @override
  List<Object?> get props => [product, quantity];
}

class ClearCart extends CartEvent {}

// States
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;

  const CartLoaded({
    required this.items,
    required this.total,
  });

  @override
  List<Object?> get props => [items, total];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

// Models
class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  double get total => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _items = [];

  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  double get _total => _items.fold(0, (sum, item) => sum + item.total);

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    try {
      final existingIndex = _items.indexWhere((item) => item.product.id == event.product.id);
      if (existingIndex != -1) {
        _items[existingIndex] = CartItem(
          product: event.product,
          quantity: _items[existingIndex].quantity + event.quantity,
        );
      } else {
        _items.add(CartItem(
          product: event.product,
          quantity: event.quantity,
        ));
      }
      emit(CartLoaded(items: List.from(_items), total: _total));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    try {
      _items.removeWhere((item) => item.product.id == event.product.id);
      emit(CartLoaded(items: List.from(_items), total: _total));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    emit(CartLoading());
    try {
      final index = _items.indexWhere((item) => item.product.id == event.product.id);
      if (index != -1) {
        if (event.quantity > 0) {
          _items[index] = CartItem(
            product: event.product,
            quantity: event.quantity,
          );
        } else {
          _items.removeAt(index);
        }
      }
      emit(CartLoaded(items: List.from(_items), total: _total));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    try {
      _items.clear();
      emit(CartLoaded(items: [], total: 0));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
} 
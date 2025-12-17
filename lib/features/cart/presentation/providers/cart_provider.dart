import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';

// Cart state class
class CartState {
  final List<CartItem> items;

  CartState({required this.items});

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get tax => subtotal * 0.08; // 8% tax

  double get total => subtotal + tax;

  CartItem? getItem(String productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  bool hasProduct(String productId) {
    return items.any((item) => item.product.id == productId);
  }
}

// Cart notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: []));

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // Update quantity if product exists
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = CartItem(
        product: product,
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
      state = CartState(items: updatedItems);
    } else {
      // Add new item
      state = CartState(
        items: [...state.items, CartItem(product: product, quantity: quantity)],
      );
    }
  }

  void removeItem(String productId) {
    state = CartState(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: quantity);
      }
      return item;
    }).toList();

    state = CartState(items: updatedItems);
  }

  void incrementQuantity(String productId) {
    final item = state.getItem(productId);
    if (item != null) {
      updateQuantity(productId, item.quantity + 1);
    }
  }

  void decrementQuantity(String productId) {
    final item = state.getItem(productId);
    if (item != null) {
      updateQuantity(productId, item.quantity - 1);
    }
  }

  void clear() {
    state = CartState(items: []);
  }
}

// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Cart item count provider
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

// Cart total provider
final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).total;
});

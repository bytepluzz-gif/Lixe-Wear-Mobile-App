import 'package:flutter/material.dart';
import '../../product/model/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cart = [];

  List<CartItem> get cart => _cart;

  double get total =>
      _cart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  void addToCart(Product product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int qty) {
    if (qty < 1) return;
    item.quantity = qty;
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}

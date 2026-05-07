import 'package:flutter/material.dart';
import '../../product/model/product.dart';
import '../../../core/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  final List<CartItem> _cart = [];
  String? _uid;

  List<CartItem> get cart => _cart;

  double get total =>
      _cart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  void attachUser(String uid) {
    _uid = uid;
    _service.cartStream(uid).listen((items) {
      _cart
        ..clear()
        ..addAll(items);
      notifyListeners();
    });
  }

  Future<void> addToCart(Product product, String size) async {
    final uid = _uid;
    if (uid == null) return;
    await _service.addToCart(uid, product, size);
  }

  Future<void> removeFromCart(CartItem item) async {
    final uid = _uid;
    if (uid == null) return;
    await _service.removeFromCart(uid, item.product, item.size);
  }

  Future<void> updateQuantity(CartItem item, int qty) async {
    final uid = _uid;
    if (uid == null) return;
    await _service.updateCartQuantity(uid, item.product, item.size, qty);
  }

  Future<void> clearCart() async {
    final uid = _uid;
    if (uid == null) return;
    await _service.clearCart(uid);
  }
}

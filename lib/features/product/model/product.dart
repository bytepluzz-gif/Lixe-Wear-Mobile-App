// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> colors;
  final List<String> sizes;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.colors = const [],
    this.sizes = const [],
    this.description = '',
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
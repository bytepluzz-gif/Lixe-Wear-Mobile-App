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

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      imageUrl: data['imageUrl'] as String? ?? '',
      category: data['category'] as String? ?? 'Uncategorized',
      colors: List<String>.from(data['colors'] as List? ?? const []),
      sizes: List<String>.from(data['sizes'] as List? ?? const []),
      description: data['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'colors': colors,
      'sizes': sizes,
      'description': description,
    };
  }
}

class CartItem {
  final Product product;
  final String size;
  int quantity;

  CartItem({required this.product, required this.size, this.quantity = 1});
}
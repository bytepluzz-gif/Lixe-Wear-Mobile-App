import '../features/product/model/product.dart';

class AppData {
  static final List<Product> allProducts = [
    Product(
      id: '1',
      name: 'Signature Wool Coat',
      price: 299.00,
      imageUrl:
          'https://images.unsplash.com/photo-1539109132381-31a1C974573f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      category: 'Outerwear',
      colors: ['Midnight Black', 'Camel', 'Slate Grey'],
      sizes: ['S', 'M', 'L', 'XL'],
      description:
          'A timeless silhouette crafted from premium Italian wool blend for ultimate warmth and elegance.',
    ),
    Product(
      id: '2',
      name: 'Essential Silk Blouse',
      price: 129.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549439602-43ebca2327af?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      category: 'Tops',
      colors: ['Ivory', 'Pearl', 'Soft Pink'],
      sizes: ['XS', 'S', 'M', 'L'],
      description:
          'Sophisticated 100% mulberry silk blouse with a tailored fit and delicate pearl buttons.',
    ),
    Product(
      id: '3',
      name: 'High-Rise Tailored Trousers',
      price: 159.00,
      imageUrl:
          'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      category: 'Bottoms',
      colors: ['Sand', 'Onyx', 'Navy'],
      sizes: ['24', '26', '28', '30', '32'],
      description:
          'Precision-cut trousers designed for a flattering high-waist fit and structured drape.',
    ),
    Product(
      id: '4',
      name: 'Cashmere Ribbed Knit',
      price: 189.00,
      imageUrl:
          'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      category: 'Knitwear',
      colors: ['Cream', 'Mocha', 'Charcoal'],
      sizes: ['S', 'M', 'L'],
      description:
          'Buttery-soft recycled cashmere sweater with a subtle ribbed texture for effortless layering.',
    ),
    Product(
      id: '5',
      name: 'Satin Slip Midi Dress',
      price: 119.00,
      imageUrl:
          'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      category: 'Dresses',
      colors: ['Champagne', 'Emerald', 'Black'],
      sizes: ['XS', 'S', 'M', 'L'],
      description:
          'Elegant satin midi dress with adjustable straps and a fluid, bias-cut silhouette.',
    ),
    Product(
      id: '6',
      name: 'Leather Biker Jacket',
      price: 450.00,
      imageUrl:
          'https://images.unsplash.com/photo-1551028711-03037ea6c4d7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      category: 'Jackets',
      colors: ['Black'],
      sizes: ['S', 'M', 'L'],
      description:
          'Genuine full-grain leather jacket with signature silver-tone hardware and quilted lining.',
    ),
  ];

  static final List<Product> recommended = allProducts.sublist(0, 4);
}

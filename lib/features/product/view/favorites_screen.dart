import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/firestore_service.dart';
import '../viewmodel/favorites_provider.dart';
import '../model/product.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final service = context.read<FirestoreService>();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: StreamBuilder<List<Product>>(
        stream: service.productsStream(),
        builder: (context, snapshot) {
          final favorites = (snapshot.data ?? [])
              .where((p) => favoritesProvider.favoriteIds.contains(p.id))
              .toList();
          if (favorites.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }
          return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/product-details',
                    arguments: product,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          const Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(Icons.favorite, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(product.name, maxLines: 2),
                      Text(
                        "\$${product.price}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            );
        },
      ),
    );
  }
}

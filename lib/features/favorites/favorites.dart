// lib/features/favorites/favorites_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to hold favorite product IDs (for simplicity)
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>(
      (ref) => FavoritesNotifier(),
);

/// Manages add/remove favorites
class FavoritesNotifier extends StateNotifier<Set<int>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(int productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }

  bool isFavorite(int productId) => state.contains(productId);
}

/// Main favorites screen
@RoutePage()
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x99CA907E),
        centerTitle: true,
        title: const Text(
          'FAVORITES',
          style: TextStyle(
            fontFamily: 'Archivo',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: favoriteIds.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            final productId = favoriteIds.elementAt(index);
            return ProductCard(
              id: productId,
              title: 'Product $productId',
              price: 20.0 + index,
              imageUrl: '', // placeholder
            );
          },
        ),
      ),
    );
  }
}

/// Product card used in favorites grid
class ProductCard extends ConsumerWidget {
  final int id;
  final String title;
  final double price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(id);
    final toggleFavorite = ref.read(favoritesProvider.notifier).toggleFavorite;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x1FCA907E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCA907E), width: 0.5),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Product Info
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Archivo',
            ),
          ),
          Text(
            '\u20AC$price',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontFamily: 'Archivo',
            ),
          ),

          // Favorite icon
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? const Color(0xFFCA907E) : Colors.grey,
              ),
              onPressed: () => toggleFavorite(id),
            ),
          ),
        ],
      ),
    );
  }
}

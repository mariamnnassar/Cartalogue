import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartalogue/features/home/logic/product_provider.dart';
import 'package:cartalogue/models/product.dart';

/// Riverpod provider for favorite product IDs
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>(
      (ref) => FavoritesNotifier(),
);

/// Notifier to manage adding/removing favorite IDs
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

/// Main Favorites Page
@RoutePage()
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final productsAsync = ref.watch(productProvider);

    // Extract the products that are marked as favorites
    final favoriteProducts = productsAsync.when(
      data: (allProducts) => allProducts
          .where((product) => favoriteIds.contains(product.id))
          .toList(),
      loading: () => [],
      error: (_, __) => [],
    );

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
        child: favoriteProducts.isEmpty
            ? const Center(child: Text('No favorite products yet.'))
            : GridView.builder(
          itemCount: favoriteProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            final product = favoriteProducts[index];
            return ProductCard(
              product: product,
            );
          },
        ),
      ),
    );
  }
}

/// Reusable product card used in the favorites grid
class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(product.id);
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
          // Product image placeholder
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

          // Product title & price
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Archivo',
            ),
          ),
          Text(
            '${product.price.toStringAsFixed(2)} JOD',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontFamily: 'Archivo',
            ),
          ),

          // Favorite toggle
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? const Color(0xFFCA907E) : Colors.grey,
              ),
              onPressed: () => toggleFavorite(product.id),
            ),
          ),
        ],
      ),
    );
  }
}

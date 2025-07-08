import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartalogue/features/home/logic/product_provider.dart';
import 'package:cartalogue/models/product.dart';
import 'package:cartalogue/core/router/app_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ✅ Added for localization

// Riverpod provider to store favorite product IDs
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>(
      (ref) => FavoritesNotifier(),
);

// StateNotifier that manages favorite IDs
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

// ✅ Favorites Page UI
@RoutePage()
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final productsAsync = ref.watch(productProvider);
    final localization = AppLocalizations.of(context)!; // ✅ Localization instance

    final favoriteProducts = productsAsync.when(
      data: (allProducts) => allProducts
          .where((product) => favoriteIds.contains(product.id))
          .toList(),
      loading: () => [],
      error: (_, __) => [],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0x99CA907E),
        centerTitle: true,
        title: Text(
          localization.favoritesTitle, // ✅ Localized title
          style: const TextStyle(
            fontFamily: 'Archivo',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: favoriteProducts.isEmpty
            ? Center(child: Text(localization.noFavorites)) // ✅ Localized empty text
            : GridView.builder(
          itemCount: favoriteProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            final product = favoriteProducts[index];
            return ProductCard(product: product);
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0x99CA907E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: 1,
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color(0xFFCA907E),
          onTap: (index) {
            if (index == 0) {
              context.pushRoute(const HomeRoute());
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 40),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 40),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Product Card widget used in the favorites grid
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Product Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: (product.image.isNotEmpty)
                  ? Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return SvgPicture.asset(
                    'assets/images/Placeholder.svg',
                    fit: BoxFit.contain,
                    color: Colors.grey[400],
                  );
                },
              )
                  : SvgPicture.asset(
                'assets/images/Placeholder.svg',
                fit: BoxFit.contain,
                color: Colors.grey[400],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 📝 Product title & price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  "${product.price.toStringAsFixed(2)} JOD",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontFamily: 'Archivo',
                  ),
                ),
              ],
            ),
          ),

          // ❤️ Favorite button
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? const Color(0xFFCA907E) : Colors.grey,
                  size: 18,
                ),
                onPressed: () => toggleFavorite(product.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cartalogue/models/product.dart';
import 'package:cartalogue/services/api_service.dart';

// 🟣 AsyncNotifier for managing product list with loading/error states
class ProductNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return await ApiService.fetchProducts();
  }

  // Update product and refresh state
  Future<void> updateProductApi(Product updatedProduct) async {
    final updated = await ApiService.updateProduct(updatedProduct.id, updatedProduct);

    // Replace the product in state with updated version
    state = AsyncData([
      for (final product in state.value ?? [])
        if (product.id == updated.id) updated else product
    ]);
  }
}

// ✅ Provider to use in UI
final productProvider = AsyncNotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

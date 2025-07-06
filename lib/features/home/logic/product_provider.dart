// lib/features/home/logic/product_provider.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:cartalogue/models/product.dart';

/// 🔁 A StateNotifier to manage the list of products (GET and PUT)
class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  /// 📦 Fetch products from the API
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      state = data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  /// ✏️ Update a product in local state after editing
  void updateProduct(Product updatedProduct) {
    state = [
      for (final product in state)
        if (product.id == updatedProduct.id) updatedProduct else product
    ];
  }
}

/// 📌 Provider to expose the ProductNotifier state
final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>(
      (ref) => ProductNotifier(),
);

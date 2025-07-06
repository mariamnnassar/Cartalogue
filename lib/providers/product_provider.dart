// lib/providers/product_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/api_service.dart';

final productListProvider = FutureProvider<List<Product>>((ref) async {
  return ApiService.fetchProducts();
});

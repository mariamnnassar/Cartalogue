// lib/features/edit_product/edit.dart
import 'package:auto_route/auto_route.dart';
import 'package:cartalogue/models/product.dart';
import 'package:cartalogue/features/home/logic/product_provider.dart';
import 'package:cartalogue/features/favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class EditPage extends ConsumerStatefulWidget {
  final Product product;

  const EditPage({super.key, required this.product});

  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    descriptionController = TextEditingController(text: widget.product.description);
    priceController = TextEditingController(text: widget.product.price.toString());

    // Check if this product is already a favorite
    final favorites = ref.read(favoritesProvider);
    isFavorite = favorites.contains(widget.product.id);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  // 🔄 Save updated product
  Future<void> _saveProduct() async {
    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    if (title.isEmpty || desc.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    final updatedProduct = widget.product.copyWith(
      title: title,
      description: desc,
      price: price,
    );

    try {
      // 🔁 Update product in the API and locally
      await ref.read(productProvider.notifier).updateProductApi(updatedProduct);

      // 🧠 Update favorites if needed
      final favNotifier = ref.read(favoritesProvider.notifier);
      final isFav = ref.read(favoritesProvider).contains(updatedProduct.id);

      if (isFavorite && !isFav) {
        favNotifier.toggleFavorite(updatedProduct.id);
      } else if (!isFavorite && isFav) {
        favNotifier.toggleFavorite(updatedProduct.id);
      }

      // 🔄 Refresh products
      ref.invalidate(productProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated ✅')),
        );
        context.popRoute();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0x99CA907E),
        centerTitle: true,
        title: const Text(
          'EDIT PRODUCT',
          style: TextStyle(
            fontFamily: 'Archivo',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Product image with fallback SVG
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: (widget.product.image.isNotEmpty)
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset(
                      'assets/images/Placeholder.svg',
                      fit: BoxFit.contain,
                      color: Colors.grey[400],
                    );
                  },
                ),
              )
                  : SvgPicture.asset(
                'assets/images/Placeholder.svg',
                fit: BoxFit.contain,
                color: Colors.grey[400],
              ),
            ),

            const SizedBox(height: 24),

            // 📝 Title field
            const Text(
              'Title',
              style: TextStyle(fontFamily: 'Archivo', color: Color(0xFF91654B)),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'e.g. Cotton T-Shirt',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 📝 Description
            const Text(
              'Description',
              style: TextStyle(fontFamily: 'Archivo', color: Color(0xFF91654B)),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'e.g. Soft cotton with round neck',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 💲 Price
            const Text(
              'Price',
              style: TextStyle(fontFamily: 'Archivo', color: Color(0xFF91654B)),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 20.00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Save and Favorite buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ❤️ Toggle favorite
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? const Color(0xFFCA907E) : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),

                const SizedBox(width: 12),

                // ✅ Save button
                ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCA907E),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'Archivo',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

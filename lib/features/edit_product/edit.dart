// lib/features/edit_product/edit.dart
import 'package:auto_route/auto_route.dart';
import 'package:cartalogue/models/product.dart';
import 'package:cartalogue/features/home/logic/product_provider.dart';
import 'package:cartalogue/features/favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        SnackBar(content: Text(AppLocalizations.of(context)!.fillFieldsError)),
      );
      return;
    }

    final updatedProduct = widget.product.copyWith(
      title: title,
      description: desc,
      price: price,
    );

    try {
      await ref.read(productProvider.notifier).updateProductApi(updatedProduct);

      final favNotifier = ref.read(favoritesProvider.notifier);
      final isFav = ref.read(favoritesProvider).contains(updatedProduct.id);

      if (isFavorite && !isFav) {
        favNotifier.toggleFavorite(updatedProduct.id);
      } else if (!isFavorite && isFav) {
        favNotifier.toggleFavorite(updatedProduct.id);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.productUpdated)),
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
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0x99CA907E),
        centerTitle: true,
        title: Text(
          localization.editProduct,
          style: const TextStyle(
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
            // 🖼️ Product image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
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

            // 📝 Title
            Text(
              localization.titleLabel,
              style: const TextStyle(fontFamily: 'Archivo', color: Color(0xFF91654B)),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: localization.titleHint,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 📝 Description
            Text(
              localization.descriptionLabel,
              style: const TextStyle(fontFamily: 'Archivo', color: Color(0xFF91654B)),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: localization.descriptionHint,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 💲 Price
            Text(
              localization.priceLabel,
              style: const TextStyle(fontFamily: 'Archivo', color: Color(0xFF91654B)),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: localization.priceHint,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ❤️ Favorite toggle
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? const Color(0xFFCA907E) : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    ref.read(favoritesProvider.notifier).toggleFavorite(widget.product.id);
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
                  child: Text(
                    localization.saveButton,
                    style: const TextStyle(
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

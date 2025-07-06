import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditProductState();
}

class _EditProductState extends State<EditPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🟤 Custom AppBar with color, spacing and font
      appBar: AppBar(
        backgroundColor: const Color(0x99CA907E), // Editable tone
        centerTitle: true,
        title: const Text(
          'EDIT PRODUCT',
          style: TextStyle(
            fontFamily: 'Archivo',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5, // 👈 spacing between letters
          ),
        ),
        elevation: 0,
      ),

      // 🧾 Main content form section
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 Title Field
            const Text(
              "Title",
              style: TextStyle(
                fontFamily: 'Archivo',
                fontSize: 14,
                color: Color(0x99CA907E), // Same tone as app bar
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'e.g. Blue Denim Jacket',
                hintStyle: const TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 13,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 💬 Description Field
            const Text(
              "Description",
              style: TextStyle(
                fontFamily: 'Archivo',
                fontSize: 14,
                color: Color(0x99CA907E),
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g. Light material, spring style...',
                hintStyle: const TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 13,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 💰 Price Field
            const Text(
              "Price",
              style: TextStyle(
                fontFamily: 'Archivo',
                fontSize: 14,
                color: Color(0x99CA907E),
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'e.g. 29.99 JOD',
                hintStyle: const TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 13,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ✅ Save and Favorite in a Row, centered
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Save Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCA907E), // You can change
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product updated!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'Archivo',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ❤️ Favorite icon
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color:
                    isFavorite ? const Color(0xFFCA907E) : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? 'Added to favorites 💖'
                              : 'Removed from favorites 🗑️',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

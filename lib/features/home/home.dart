import 'package:flutter/material.dart';
import 'package:cartalogue/features/edit_product/edit.dart';
import 'package:cartalogue/features/favorites/favorites.dart'; // <-- Import FavoritesScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Main screen content
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔄 Language toggle (Android-style)
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("EN"),
                    Switch(
                      value: true,
                      onChanged: (val) {},
                      activeColor: const Color(0xFFCA907E),
                    ),
                    const Text("AR"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 🅰️ App name
              const Text(
                "Cartalogue",
                style: TextStyle(
                  fontSize: 34,
                  fontFamily: 'Archivo',
                  color: Color(0xFFCA907E),
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(2, 1),
                      blurRadius: 1,
                    )
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // 🗯️ Subtitle
              const Text(
                "Quick and smart product detail editing🌟",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'Archivo',
                ),
              ),

              const SizedBox(height: 12),

              // Divider line
              const Divider(
                thickness: 1,
                color: Color(0xFF91654B),
              ),

              const SizedBox(height: 12),

              // Section title
              const Text(
                "Explore Products",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Archivo',
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // 🧱 Product cards grid
              Expanded(
                child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.62, // taller card
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0x1FCA907E), // 12% opacity
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFCA907E),
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🖼️ Product image
                          Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 📝 Product title & price
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Product Title",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Archivo',
                                  ),
                                ),
                                Text(
                                  "20.0 JOD",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    fontFamily: 'Archivo',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // ✏️ Edit icon at bottom right
                          Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCA907E),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EditProduct(),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom navigation bar with navigation to favorites
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0x99CA907E), // 60% opacity
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Color(0xFFCA907E),
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 40),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, size: 40),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}

// lib/features/home/home.dart

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main screen layout
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🧭 Language switch row
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("EN"),
                    Switch(value: true, onChanged: null), // Temporary
                    Text("AR"),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 🛍️ App Title
              const Text(
                "Cartalogue",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFCA907E),
                ),
              ),

              const SizedBox(height: 4),

              // 💬 Subtitle
              const Text(
                "Quick and smart product detail editing",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              // 📦 Section title
              const Text(
                "Explore Products",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // 🖼️ Grid of product cards
              Expanded(
                child: GridView.builder(
                  itemCount: 8, // static number for UI demo
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF9F2EF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFCA907E)),
                      ),
                      child: Column(
                        children: [
                          // Product image placeholder
                          Expanded(
                            child: Container(
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text("Product Title"),
                          const Text("20.0 JOD"),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.edit, size: 16),
                          )
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

      // ❤️ Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Home selected
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
        ],
      ),
    );
  }
}

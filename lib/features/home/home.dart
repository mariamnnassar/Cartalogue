// lib/features/home/home.dart

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cartalogue/core/router/app_router.dart';
import 'package:cartalogue/features/favorites/favorites.dart';
import 'package:cartalogue/features/home/logic/product_provider.dart';
import 'package:cartalogue/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // ✅ Fetch products automatically using AsyncNotifier's build method
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌐 Language switcher (currently static)
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

              // 📝 Subtitle
              const Text(
                "Quick and smart product detail editing🌟",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'Archivo',
                ),
              ),

              const SizedBox(height: 12),

              // Divider
              const Divider(
                thickness: 1,
                color: Color(0xFF91654B),
              ),

              const SizedBox(height: 12),

              // Section Title
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

              // 🧱 Products grid OR loading/error
              Expanded(
                child: productsAsync.when(
                  data: (products) => GridView.builder(
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.62,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0x1FCA907E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFCA907E),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🖼️ Product image or SVG fallback
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
                                'assets/images/placeholder.svg',
                                fit: BoxFit.contain,
                                color: Colors.grey[400],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 📄 Title & Price
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Archivo',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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

                            const Spacer(),

                            // ✏️ Edit Button
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
                                      context.pushRoute(EditRoute(product: product));
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
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔻 Bottom Navigation
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
          currentIndex: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Color(0xFFCA907E),
          onTap: (index) {
            if (index == 1) {
              context.pushRoute(const FavoritesRoute());
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

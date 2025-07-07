// lib/models/product.dart

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  Product copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image, category: '',
    );
  }

  // Factory to create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }

  // Convert Product back to JSON (for PUT)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
  }
}

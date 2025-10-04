import 'dart:io';

class Product {
  String id;
  String name;
  String category;
  double price;
  int stock;
  String unit;
  String description;
  String phone;
  String location;
  List<String> imagePaths; // Storing paths for images
  String seller;
  String date;
  bool featured;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.unit,
    required this.description,
    required this.phone,
    required this.location,
    required this.imagePaths,
    required this.seller,
    required this.date,
    this.featured = false,
  });

  // Convert a Product object into a Map object for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'unit': unit,
      'description': description,
      'phone': phone,
      'location': location,
      'imagePaths': imagePaths.join(','), // Store image paths as a comma-separated string
      'seller': seller,
      'date': date,
      'featured': featured ? 1 : 0, // SQLite doesn't have a boolean type
    };
  }

  // Extract a Product object from a Map object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      price: map['price'],
      stock: map['stock'],
      unit: map['unit'],
      description: map['description'],
      phone: map['phone'],
      location: map['location'],
      imagePaths: (map['imagePaths'] as String).split(','), // Convert string back to list
      seller: map['seller'],
      date: map['date'],
      featured: map['featured'] == 1 ? true : false,
    );
  }
}
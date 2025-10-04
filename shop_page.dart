import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Mock products data
final String productsJson = '''
{
  "products": [
   {
  "id": "1",
  "name": "بذور طماطم هجينة قرمزية",
  "category": "seeds",
  "price": 28.0,
  "supplier": "شركة بذور الوطن – سوسة",
  "supplierLogo": "🌱",
  "description": "بذور طماطم مقاومة للأمراض صالحة للزراعة في مناخ الساحل.",
  "stock": 150,
  "unit": "كيس 100 بذرة",
  "image": "https://images.unsplash.com/photo-1592841200221-a6898f307baa?w=400",
  "featured": true
},
{
  "id": "2",
  "name": "سماد بلدي NPK طبيعي 50كغ",
  "category": "fertilizers",
  "price": 47.0,
  "supplier": "التعاونية الفلاحية بصفاقس",
  "supplierLogo": "🏭",
  "description": "سماد طبيعي يحسّن خصوبة الأرض ويناسب الزيتون والحبوب.",
  "stock": 90,
  "unit": "كيس 50 كغ",
  "image": "https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400",
  "featured": false
},
{
  "id": "3",
  "name": "علف أبقار حلوب مركّز",
  "category": "animal_food",
  "price": 82.0,
  "supplier": "مؤسسة أعلاف الوسط – القيروان",
  "supplierLogo": "🐄",
  "description": "علف متوازن يزيد في إنتاج الحليب حتى 15٪.",
  "stock": 200,
  "unit": "كيس 25 كغ",
  "image": "https://images.unsplash.com/photo-1500595046743-cd271d694d30?w=400",
  "featured": true
},
    {
      "id": "4",
      "name": "مجرفة فلاحية احترافية",
      "category": "tools",
      "price": 18.5,
      "supplier": "معدات الفلاح الحديث",
      "supplierLogo": "🔧",
      "description": "مجرفة قوية من الفولاذ المقاوم للصدأ مع مقبض خشبي",
      "stock": 50,
      "unit": "قطعة",
      "image": "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400",
      "featured": false
    },
    {
      "id": "5",
      "name": "بذور فلفل حار كابسيكوم",
      "category": "seeds",
      "price": 15.0,
      "supplier": "شركة الأمل للبذور",
      "supplierLogo": "🌱",
      "description": "بذور فلفل حار ذات نكهة قوية ومميزة، مناسب للتصدير",
      "stock": 120,
      "unit": "كيس 50 بذرة",
      "image": "https://m.media-amazon.com/images/I/81-+7UI-LaL.jpg",
      "featured": false
    },
    {
      "id": "6",
      "name": "علف دواجن للتسمين",
      "category": "animal_food",
      "price": 32.0,
      "supplier": "مؤسسة الرعي الأخضر",
      "supplierLogo": "🐄",
      "description": "علف متكامل لتسمين الدجاج سريع النمو خلال 45 يوم",
      "stock": 300,
      "unit": "كيس 25 كغ",
      "image": "https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400",
      "featured": true
    },
    {
      "id": "7",
      "name": "خرطوم ري بالتنقيط 50م",
      "category": "irrigation",
      "price": 55.0,
      "supplier": "معدات الفلاح الحديث",
      "supplierLogo": "🔧",
      "description": "نظام ري بالتنقيط موفر للمياه بنسبة 60٪",
      "stock": 40,
      "unit": "لفة 50 متر",
      "image": "https://images.unsplash.com/photo-1625246277341-9e9330c68317?w=400",
      "featured": false
    },
    {
      "id": "8",
      "name": "بذور خيار هولندي",
      "category": "seeds",
      "price": 12.0,
      "supplier": "شركة الأمل للبذور",
      "supplierLogo": "🌱",
      "description": "بذور خيار هجين مثالية للزراعة تحت البيوت المحمية",
      "stock": 90,
      "unit": "كيس 50 بذرة",
      "image": "https://images.unsplash.com/photo-1604977042946-1eecc30f269e?w=400",
      "featured": false
    },
    {
      "id": "9",
      "name": "مبيد حشري عضوي",
      "category": "pesticides",
      "price": 28.0,
      "supplier": "الشركة الوطنية للأسمدة",
      "supplierLogo": "🏭",
      "description": "مبيد حشري طبيعي آمن على النباتات والبيئة",
      "stock": 65,
      "unit": "لتر",
      "image": "https://images.unsplash.com/photo-1614730321146-b6fa6a46bcb4?w=400",
      "featured": false
    },
    {
      "id": "10",
      "name": "مضخة ري كهربائية 2 حصان",
      "category": "irrigation",
      "price": 320.0,
      "supplier": "معدات الفلاح الحديث",
      "supplierLogo": "🔧",
      "description": "مضخة قوية للري، استهلاك منخفض للكهرباء",
      "stock": 15,
      "unit": "قطعة",
      "image": "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400",
      "featured": true
    }
  ]
}
''';

// Shop Page
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  String selectedCategory = "all";
  String searchQuery = "";

  final Map<String, String> categories = {
    "all": "الكل",
    "seeds": "بذور",
    "tools": "معدات",
    "animal_food": "أعلاف",
    "fertilizers": "أسمدة",
    "pesticides": "مبيدات",
    "irrigation": "ري",
  };

  final Map<String, IconData> categoryIcons = {
    "all": Icons.apps,
    "seeds": Icons.eco,
    "tools": Icons.construction,
    "animal_food": Icons.pets,
    "fertilizers": Icons.grass,
    "pesticides": Icons.bug_report,
    "irrigation": Icons.water_drop,
  };

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() {
    final data = json.decode(productsJson);
    setState(() {
      allProducts = data['products'];
      filteredProducts = allProducts;
    });
  }

  void filterProducts() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        final matchesCategory = selectedCategory == "all" ||
            product['category'] == selectedCategory;
        final matchesSearch = product['name']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final featuredProducts =
    allProducts.where((p) => p['featured'] == true).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("التسوق", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "ابحث عن منتج أو مورد...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                searchQuery = value;
                filterProducts();
              },
            ),
          ),

          // Horizontal categories
          Container(
            height: 100,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories.keys.elementAt(index);
                final isSelected = selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      filterProducts();
                    });
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryIcons[category],
                          color: isSelected ? Colors.white : Colors.grey[700],
                          size: 32,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          categories[category]!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 4),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured products from suppliers
                  if (featuredProducts.isNotEmpty && selectedCategory == "all") ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange[50]!, Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 24),
                              const SizedBox(width: 8),
                              const Text(
                                "منتجات مميزة من شركائنا",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              itemCount: featuredProducts.length,
                              itemBuilder: (context, index) {
                                return _buildFeaturedCard(featuredProducts[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // All products
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${filteredProducts.length} منتج",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Text(
                          "جميع المنتجات",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(filteredProducts[index]);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(dynamic product) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              product['image'],
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 140,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 140,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),

          // Product info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(product['supplierLogo'], style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product['supplier'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    "${product['price']} د.ت",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product['image'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[400]),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  if (product['featured'] == true)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "جديد",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            product['supplierLogo'],
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              product['supplier'],
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${product['price']} د.ت",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "متوفر: ${product['stock']}",
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
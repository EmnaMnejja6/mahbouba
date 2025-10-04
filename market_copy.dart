import 'package:flutter/material.dart';

class MarketCopy extends StatefulWidget {
  const MarketCopy({super.key});

  @override
  State<MarketCopy> createState() => _MarketCopyState();
}

class _MarketCopyState extends State<MarketCopy> {
  final List<Map<String, dynamic>> categories = [
    {
      "title": "الإنتاج النباتي",
      "icon": Icons.local_florist,
      "color": Colors.green
    },
    {
      "title": "الإنتاج الحيواني",
      "icon": Icons.pets,
      "color": Colors.pink
    },
    {
      "title": "الفلاحة المندمجة",
      "icon": Icons.agriculture,
      "color": Colors.teal
    },
    {
      "title": "التحويل الأولي المندمج",
      "icon": Icons.factory,
      "color": Colors.indigo
    },
    {
      "title": "الخدمات",
      "icon": Icons.local_shipping,
      "color": Colors.orange
    },
    {
      "title": "الصيد البحري و تربية الأحياء المائية",
      "icon": Icons.set_meal,
      "color": Colors.blue
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("السوق"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // عمودين
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1, // مربعات متناسقة
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryPage(
                          title: category["title"] ?? "صفحة")),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: category["color"],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category["icon"], size: 50, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      category["title"],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// صفحة مؤقتة لعرض عند الضغط
class CategoryPage extends StatelessWidget {
  final String title;
  const CategoryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "مرحبا بك في صفحة $title",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

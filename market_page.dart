import 'package:flutter/material.dart';
import 'package:agriwie/screens/productlist_page.dart';
import 'package:agriwie/screens/sell_item.dart';
import 'package:agriwie/screens/shop_page.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final List<Map<String, dynamic>> categories = [
    {
      "title": "أبيع منتجي",
      "icon": Icons.sell,
      "color": Colors.green
    },
    {
      "title":"أتسوق",
      "icon": Icons.shopping_cart,
      "color": Colors.pink
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("السوق"),
        centerTitle: true,

      ),
      body: Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/images/market_bg.jpg"), // put your image here
    fit: BoxFit.cover, // covers whole screen
    opacity: 0.1,      // makes it soft so text/icons stay clear
    ),
    ),
    child: Center(
    child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: categories.map((category) {
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: InkWell(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    CategoryPage(title: category["title"] ?? "صفحة"),
    ),
    );
    },
    child: Container(
    width: 160,
    height: 160,
    decoration: BoxDecoration(
    color: category["color"].withOpacity(0.85), // blend with bg
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
    color: Colors.white,
    ),
    textAlign: TextAlign.center,
    ),
    ],
    ),
    ),
    ),
    );
    }).toList(),
    ),
    ),
    ),
    ),

    );
  }
}
class CategoryPage extends StatelessWidget {
  final String title;
  const CategoryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    if (title == "أتسوق") {
      return const ShopPage();
    }
    else if (title == "أبيع منتجي") {
      return const ProductListPage();
    }

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
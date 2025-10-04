import 'package:agriwie/screens/learn_page.dart';
import 'package:agriwie/screens/ClusterCommunity_page.dart';
import 'screens/home_page.dart';
import 'package:flutter/material.dart';
import 'screens/market_page.dart';
class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    MarketPage(),
    LearnPage(),
    ClusterCommunityPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF4CAF50),
        unselectedItemColor: Color(0xFF757575),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'متجري',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'تعلم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'مجموعتي',
          ),
        ],
      ),
    );
  }
}

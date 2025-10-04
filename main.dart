import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رائدات الأعمال الريفيات',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      // Use splash screen to check first launch
      home: SplashScreen(),
      // Define routes for navigation
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/main': (context) => MainNavigationScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    // Wait a bit for splash effect (optional)
    await Future.delayed(Duration(seconds: 1));

    if (isFirstLaunch) {
      // First time - show onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } else {
      // Not first time - go directly to main app
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E7D32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.agriculture,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'رائدات الأعمال الريفيات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
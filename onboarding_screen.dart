import 'package:agriwie/screens/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;

  List<OnboardingData> onboardingPages = [
    OnboardingData(
      title: "يزي من 10 دت في النهار!",
      subtitle: "جاء الوقت تولي رايدة أعمال وتبدا مشروعك✨",
      image: "assets/images/women_working.jpg",
      backgroundColor: Color(0xFFE53935),
    ),
    OnboardingData(
      title: "حديقتك الصغيرة = مشروعك الكبير 🌱",
      subtitle: "إبدا من دارك، من غير مصاريف ",
      image: "assets/images/garden.jpg",
      backgroundColor: Color(0xFF43A047),
    ),
    OnboardingData(
      title: "ما عادش تعرّض روحك للخطر في الطريق 🚫",
      subtitle: "صحتك وراحتك أهم من الكل 💕",
      image: "assets/images/safe_home.jpg",
      backgroundColor: Color(0xFF1976D2),
    ),
    OnboardingData(
      title: "إحنا معاك في كل خطوة 💪",
      subtitle: "نوجهوك ونعلموك بش تنجح",
      image: "assets/images/support.jpg",
      backgroundColor: Color(0xFF7B1FA2),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return _buildOnboardingPage(onboardingPages[index]);
            },
          ),

          // Page indicators
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                    (index) => _buildDot(index),
              ),
            ),
          ),

          // Navigation buttons
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage > 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: Text(
                      "السابق",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )
                else
                  SizedBox(),

                ElevatedButton(
                  onPressed: () {
                    if (currentPage < onboardingPages.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    currentPage < onboardingPages.length - 1 ? "التالي" : "ابدئي الآن",
                    style: TextStyle(
                      color: onboardingPages[currentPage].backgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(data.image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title card
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(currentPage == index ? 1.0 : 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

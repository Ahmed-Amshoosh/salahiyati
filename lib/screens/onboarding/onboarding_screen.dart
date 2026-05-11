import 'package:expiry_guard/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  int currentIndex = 0;

  final List onboardingData = [
    {
      "title": "امسح الباركود وتتبع منتجاتك",
      "description":
          "امسح الباركود لأي منتج بسهولة\nوتتبع تواريخ الانتهاء لحظة بلحظة",
      "image": "assets/images/onboarding2.png",
    },

    {
      "title": "احمِ صحة عائلتك",
      "description": "نبّهك قبل انتهاء صلاحية المنتجات\nوتجنب المخاطر الصحية",
      "image": "assets/images/onboarding3.png",
    },

    {
      "title": "وفر مالك وقلل الهدر",
      "description": "خطط مشترياتك بذكاء\nواستهلك قبل الانتهاء لتوفر أكثر",
      "image": "assets/images/onboarding4.png",
    },
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        controller.animateToPage(
          1,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );

        setState(() {
          currentIndex = 1;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,

        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        children: [
          /// الصفحة الأولى (الخضراء)
          _buildSplashPage(),

          /// الصفحات الأخرى
          ...List.generate(
            onboardingData.length,
            (index) => _buildOnboardingPage(
              title: onboardingData[index]["title"],
              description: onboardingData[index]["description"],
              image: onboardingData[index]["image"],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplashPage() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 107, 66),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              /// المحتوى بالنص
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// شعار
                    Image.asset("assets/images/onboarding1.png"),

                    const SizedBox(height: 120),

                    /// عنوان
                    const Text(
                      "مرحباً بك في صلاحتي",
                      style: TextStyle(
                        color: Color.fromARGB(216, 255, 255, 255),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// عنوان فرعي
                    const Text(
                      "تتبع المنتجات، حافظ على صحتك، وفر مالك",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(224, 255, 255, 255),
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),

              /// الخط السفلي
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// صفحات onboarding
  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required String image,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    Image.asset("assets/images/logo2.png", width: 100),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: TextButton(
                    onPressed: () {
                      controller.animateToPage(
                        3,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },

                    child: const Text(
                      "تخطي",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            /// الصورة
            Image.asset(image, width: double.infinity, fit: BoxFit.contain),

            const SizedBox(height: 40),

            /// العنوان
            Text(
              title,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B8F4D),
              ),
            ),

            const SizedBox(height: 20),

            /// الوصف
            Text(
              description,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                height: 1.7,
              ),
            ),

            const Spacer(),

            if (currentIndex == 3)
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 107, 66),
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();

                    await prefs.setBool('onboarding_done', true);
                    print(prefs.getBool('onboarding_done'));

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },

                  child: const Text(
                    "ابدأ الآن",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  TextButton(
                    onPressed: () {
                      controller.animateToPage(
                        3,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },

                    child: const Text(
                      "تخطي",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SmoothPageIndicator(
                    controller: controller,

                    count: 4,

                    effect: const WormEffect(
                      activeDotColor: Color(0xFF0B8F4D),
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),

                  /// التالي
                  TextButton(
                    onPressed: () {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },

                    child: const Text(
                      "التالي",
                      style: TextStyle(
                        color: Color(0xFF0B8F4D),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

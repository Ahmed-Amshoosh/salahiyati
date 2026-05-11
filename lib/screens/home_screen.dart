import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_guard/screens/add_product_screen.dart';
import 'package:expiry_guard/screens/notifications.dart';
import 'package:expiry_guard/screens/products_screen.dart';
import 'package:expiry_guard/screens/profile_screen.dart';
import 'package:expiry_guard/screens/reports_screen.dart';
import 'package:expiry_guard/screens/scanner_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadUser();
  }
 String userName = "مستخدم";
  Future<void> loadUser() async {
   
    final user = FirebaseAuth.instance.currentUser;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      userName = doc['name'] ?? 'مستخدم';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      /// Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Colors.white,
        elevation: 15,

        child: SizedBox(
          height: 75,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              /// الرئيسية
              _bottomItem(
                icon: Icons.home,
                label: "الرئيسية",
                isActive: true,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
              ),

              /// المنتجات
              _bottomItem(
                icon: Icons.inventory_2_outlined,
                label: "المنتجات",

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductsScreen()),
                  );
                },
              ),

              /// فراغ
              const SizedBox(width: 40),

              /// التنبيهات
              _bottomItem(
                icon: Icons.notifications_none,
                label: "التنبيهات",

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              ),

              /// المزيد
              _bottomItem(
                icon: Icons.more_horiz,
                label: "المزيد",

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Container(
        height: 50,
        width: 50,

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF0B8F4D),

          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),

        child: FloatingActionButton(
          backgroundColor: const Color(0xFF0B8F4D),
          elevation: 0,

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScannerScreen()),
            );
          },

          child: const Icon(
            Icons.qr_code_scanner,
            size: 34,
            color: Colors.white,
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              /// ================= HEADER =================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.only(
                  top: 50,
                  right: 20,
                  left: 20,
                  bottom: 20,
                ),

                decoration: const BoxDecoration(
                  color: Color(0xFF0B8F4D),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),

                child: Column(
                  children: [
                    /// TOP BAR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "مرحباً $userName",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "هيا نتحقق من منتجاتك اليوم",
                              style: TextStyle(
                                color: Color.fromARGB(220, 255, 255, 255),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ALERT CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            color: Colors.red,
                            size: 35,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "تنبيهات عاجلة",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),

                                SizedBox(height: 8),

                                Text(
                                  "3 منتجات تنتهي خلال 3 أيام",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "عرض الكل",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// ================= CATEGORIES =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: const [
                    Text(
                      "فئات المنتجات",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "عرض الكل",
                      style: TextStyle(
                        color: Color(0xFF0B8F4D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8), // 👈 هنا قللنا المسافة

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  mainAxisSpacing: 8,
                  crossAxisSpacing: 12,

                  childAspectRatio: 0.62,

                  padding: EdgeInsets.zero, // 👈 أهم حل هنا

                  children: const [
                    CategoryCard(
                      title: "الألبان",
                      count: "12 منتج",
                      emoji: "🥛",
                    ),
                    CategoryCard(
                      title: "المعلبات",
                      count: "8 منتجات",
                      emoji: "🥫",
                    ),
                    CategoryCard(
                      title: "مشروبات",
                      count: "6 منتجات",
                      emoji: "🧃",
                    ),
                    CategoryCard(
                      title: "وجبات",
                      count: "10 منتجات",
                      emoji: "🍟",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ================= QUICK VIEW =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "نظرة سريعة",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: const [
                        Expanded(
                          child: StatsCard(number: "36", title: "المنتجات"),
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: StatsCard(number: "7", title: "قريبة"),
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: StatsCard(number: "0", title: "منتهية"),
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: StatsCard(number: "125", title: "SAR"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ================= BUTTON =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B8F4D),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProductScreen(),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),

                    label: const Text(
                      "إضافة منتج جديد",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B8F4D),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReportsScreen(),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),

                    label: const Text(
                      "الاحصائيات",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _bottomItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  bool isActive = false,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),

    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF0B8F4D) : Colors.grey,
            size: 20,
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF0B8F4D) : Colors.grey,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}

/// ================= CATEGORY CARD =================
class CategoryCard extends StatelessWidget {
  final String title;
  final String count;
  final String emoji;

  const CategoryCard({
    super.key,
    required this.title,
    required this.count,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),

          const SizedBox(height: 6),

          FittedBox(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),

          const SizedBox(height: 4),

          FittedBox(
            child: Text(
              count,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= STATS CARD =================
class StatsCard extends StatelessWidget {
  final String number;
  final String title;

  const StatsCard({super.key, required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            number,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

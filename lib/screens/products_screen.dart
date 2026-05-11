import 'package:expiry_guard/screens/product_details.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,

          leading: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings_outlined, color: Color(0xFF0B8F4D)),
          ),

          centerTitle: true,

          title: const Text(
            "منتجاتي",
            style: TextStyle(
              color: Color(0xFF0B8F4D),
              fontWeight: FontWeight.bold,
            ),
          ),

          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              /// SEARCH
              TextField(
                decoration: InputDecoration(
                  hintText: "ابحث عن منتج...",
                  prefixIcon: const Icon(Icons.search),

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// FILTERS
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_alt_outlined),
                          SizedBox(width: 8),
                          Text("تصفية"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      height: 45,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.swap_vert),
                          SizedBox(width: 8),
                          Text("ترتيب"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,

                child: Text(
                  "36 منتج",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// PRODUCTS
              Expanded(
                child: ListView(
                  children: const [
                    ProductCard(
                      image: "🥛",
                      title: "حليب كامل الدسم",
                      category: "ألبان",
                      days: "3 أيام",
                      expiryDate: "2024-05-20",
                      color: Colors.red,
                    ),
                    ProductCard(
                      image: "🧀",
                      title: "جبنة شيدر",
                      category: "ألبان",
                      days: "7 أيام",
                      expiryDate: "2024-05-20",
                      color: Colors.orange,
                    ),

                    ProductCard(
                      image: "🍅",
                      title: "صلصة طماطم",
                      category: "معلبات",
                      days: "12 يوم",
                      expiryDate: "2024-05-20",
                      color: Colors.orange,
                    ),

                    ProductCard(
                      image: "🍚",
                      title: "أرز بسمتي",
                      category: "حبوب",
                      days: "45 يوم",
                      expiryDate: "2024-05-20",
                      color: Colors.green,
                    ),

                    ProductCard(
                      image: "🫒",
                      title: "زيت زيتون",
                      category: "زيوت",
                      days: "90 يوم",
                      expiryDate: "2024-05-20",
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String category;
  final String days;
  final String expiryDate;
  final Color color;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.category,
    required this.days,
    required this.expiryDate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductDetailsScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),

        child: Row(
          children: [
            /// 🔽 زر المزيد (يسار)
            Container(
              padding: const EdgeInsets.only(left: 8),

              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Color.fromARGB(88, 158, 182, 193),
                    width: 1.9, // خفيف جدًا
                  ),
                ),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                  ),

                  const SizedBox(height: 2),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      days,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// 🟢 النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(category, style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 6),

                  /// ⏳ الأيام
                  Text(
                    "ينتهي خلال $days",
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  /// 📅 تاريخ الانتهاء
                  Text(
                    "تاريخ الانتهاء: $expiryDate",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// 🖼️ الصورة (يمين)
            Text(image, style: const TextStyle(fontSize: 40)),
          ],
        ),
      ),
    );
  }
}

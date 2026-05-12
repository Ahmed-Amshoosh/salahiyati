import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_guard/screens/edit_product_screen.dart';
import 'package:expiry_guard/screens/product_details.dart';
import 'package:expiry_guard/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Stream<QuerySnapshot> getProducts() {
    return FirebaseFirestore.instance.collection('products').snapshots();
  }

  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();

    setState(() {
      products = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection('products').doc(id).delete();

    await loadProducts();
  }

  int getDaysLeft(String expiryDate) {
    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();

      return expiry.difference(now).inDays;
    } catch (e) {
      return 999; // إذا التاريخ غلط
    }
  }

  Color getExpiryColor(int daysLeft) {
    if (daysLeft < 0) {
      return Colors.red; // منتهي
    } else if (daysLeft <= 3) {
      return Colors.orange; // قريب
    } else {
      return Colors.green; // آمن
    }
  }

  String searchQuery = "";
  String selectedCategory = "الكل";
  bool sortAsc = true;
  List products = [];
  List getFilteredProducts() {
    final list = products.where((product) {
      final name = (product['name'] ?? "").toString().toLowerCase();
      final category = (product['category'] ?? "").toString();

      final matchSearch = name.contains(searchQuery.toLowerCase());

      final matchCategory =
          selectedCategory == "الكل" || category == selectedCategory;

      return matchSearch && matchCategory;
    }).toList();

    list.sort((a, b) {
      final aDate =
          DateTime.tryParse(a['expirationDate'] ?? "") ?? DateTime(9999);
      final bDate =
          DateTime.tryParse(b['expirationDate'] ?? "") ?? DateTime(9999);

      return sortAsc ? aDate.compareTo(bDate) : bDate.compareTo(aDate);
    });

    return list;
  }

  Widget build(BuildContext context) {
    final filteredProducts = getFilteredProducts();

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
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
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

                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text("الكل"),
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "الكل";
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("ألبان"),
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "ألبان";
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("وجبات"),
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "وجبات";
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("مشروبات"),
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "مشروبات";
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("حلويات"),
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "حلويات";
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("معلبات"),
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "معلبات";
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("أدوية"),
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "أدوية";
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
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

                      child: InkWell(
                        onTap: () {
                          setState(() {
                            sortAsc = !sortAsc;
                          });
                        },
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
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  filteredProducts.length == 1
                      ? "منتج واحد"
                      : "${filteredProducts.length} منتجات",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// PRODUCTS
              Expanded(
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    final daysLeft = getDaysLeft(
                      product['expirationDate'] ?? "",
                    );
                    final color = getExpiryColor(daysLeft);

                    return ProductCard(
                      onDelete: (id) async {
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(id)
                            .delete();

                        await loadProducts();
                        CustomSnackBar.success(context, "تم حذف المنتج بنجاح");
                      },
                       onUpdated: loadProducts, 
                      image: product['imageUrl'] ?? "",
                      title: product['name'] ?? "",
                      category: product['category'] ?? "",
                      productData: product,
                      days: daysLeft < 0 ? "منتهي" : "باقي $daysLeft يوم",
                      expiryDate: product['expirationDate'] ?? "",
                      color: color,
                    );
                  },
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
  final Future<void> Function()? onUpdated;
  final Function(String id) onDelete;
  final Map<String, dynamic> productData;
  final Color color;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.category,
    this.onUpdated,
    required this.onDelete,
    required this.productData,
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
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) async {
                      if (value == "edit") {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditProductScreen(product: productData),
                          ),
                        );

                        if (result == true) {
                          onUpdated?.call(); // 🔥 أهم سطر
                        }
                      } else if (value == "delete") {
                        onDelete(productData['id']);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "edit",
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 10),
                            Text("تعديل"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 10),
                            Text("حذف"),
                          ],
                        ),
                      ),
                    ],
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_guard/screens/home_screen.dart';
import 'package:expiry_guard/screens/login_screen.dart';
import 'package:expiry_guard/screens/notifications.dart';
import 'package:expiry_guard/screens/products_screen.dart';
import 'package:expiry_guard/services/image_service.dart';
import 'package:expiry_guard/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  String name = "";
  String email = "";
  String image = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    final data = doc.data();

    setState(() {
      name = data?['name'] ?? "";
      email = data?['email'] ?? "";
      image = data?['image'] ?? "";
      nameController.text = name;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked == null) return;

    File file = File(picked.path);

    /// 🔥 رفع إلى ImgBB
    final url = await ImageService.uploadImageToImgBB(file);

    if (url == null) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    /// 🔥 تخزين في Firebase
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "image": url,
    });

    setState(() {
      image = url;
    });
  }

  Future<void> saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "name": name,
        // البريد ممنوع تغييره
      });
      CustomSnackBar.success(context, "تم حفظ التعديلات بنجاح ");
    
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: $e"), backgroundColor: Colors.red),
      );
    }
  }

  bool isEditingName = false;
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: Color(0xFF0B8F4D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Header
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// الصورة
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF0B8F4D),
                          backgroundImage: (image.isNotEmpty)
                              ? NetworkImage(image)
                              : null,
                          child: (image.isEmpty)
                              ? Text(
                                  name.isNotEmpty ? name[0] : "U",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0B8F4D),
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              onTap: pickImage,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// الاسم كحقل
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: Color(0xFF0B8F4D)),

                          const SizedBox(width: 10),

                          Expanded(
                            child: TextField(
                              controller: nameController,
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "الاسم",
                              ),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// الإيميل كحقل
                    _infoField("البريد الإلكتروني", email, Icons.email),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Menu Items
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B8F4D),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: saveProfile,
                  child: const Text(
                    'حفظ التعديلات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Logout Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  child: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

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
              _bottomItem(
                icon: Icons.home_outlined,
                label: "الرئيسية",
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
              ),
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
              const SizedBox(width: 40),
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
              _bottomItem(
                icon: Icons.more_horiz,
                label: "المزيد",
                isActive: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF0B8F4D),
          boxShadow: [
            BoxShadow(color: Colors.green, blurRadius: 10, spreadRadius: 5),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF0B8F4D),
          elevation: 0,
          onPressed: () {},
          child: const Icon(
            Icons.qr_code_scanner,
            size: 34,
            color: Colors.white,
          ),
        ),
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _infoField(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0B8F4D)),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF0B8F4D)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
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
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF0B8F4D) : Colors.grey,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text('تسجيل الخروج'),
        ),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },

            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

            child: const Text('خروج'),
          ),
        ],
      ),
    );
  }
}

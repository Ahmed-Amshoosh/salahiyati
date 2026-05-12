import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_guard/screens/scanner_screen.dart';
import 'package:expiry_guard/widgets/customInput.dart';
import 'package:flutter/material.dart';import 'package:expiry_guard/services/image_service.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  int selectedTab = 0; // 0 = إدخال يدوي, 1 = مسح الباركود
  final ImagePicker _picker = ImagePicker();

  // الحقول
  final TextEditingController nameController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String? barcode;
  XFile? productImage;
  final List<String> categories = [
    "ألبان",
    "مشروبات",
    "معلبات",
    "وجبات",
    "حلويات",
    "أدوية",
  ];

  String? selectedCategory;
  String? imageUrl;

  bool isLoadingProduct = false;
  bool isLoading = false;

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        productImage = image;
      });
    }
  }

  Future<void> fetchProductByBarcode(String barcode) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final cleanCode = barcode.trim();

      if (cleanCode.isEmpty) return;

      /// 1️⃣ Firebase Search
      final query = await FirebaseFirestore.instance
          .collection('products')
          .where('barcode', isEqualTo: cleanCode)
          .limit(1)
          .get();

      if (!mounted) return;

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();

        setState(() {
          nameController.text = data['name'] ?? '';
          selectedCategory = data['category'];
          barcodeController.text = cleanCode;
          expirationController.text = data['expirationDate'] ?? '';
          quantityController.text = data['quantity'] ?? '';
          notesController.text = data['notes'] ?? '';
        });

        return; // ⛔ توقف هنا إذا وجد في Firebase
      }

      /// 2️⃣ API Search (OpenFoodFacts)
      final url =
          'https://world.openfoodfacts.org/api/v0/product/$cleanCode.json';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("فشل الاتصال بالـ API")));
        return;
      }

      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 1) {
        final product = jsonData['product'];
        print(product);
        print(jsonData['product']);
        final name = product['product_name'] ?? '';
        final image = product['image_thumb_url'] ?? '';

        setState(() {
          nameController.text = name;
          barcodeController.text = cleanCode;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("المنتج غير موجود في API")),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("خطأ في الاتصال")));
    }

    setState(() => isLoading = false);
  }

  String? uploadedImageUrl;
  Future<void> saveProduct() async {
    try {
      setState(() {
        isLoading = true;
      });

      /// 1️⃣ التحقق من الحقول
      if (nameController.text.isEmpty ||
          selectedCategory == null ||
          expirationController.text.isEmpty ||
          quantityController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("يرجى تعبئة جميع الحقول")));

        return;
      }

      /// 2️⃣ منع التكرار
      final existing = await FirebaseFirestore.instance
          .collection('products')
          .where('barcode', isEqualTo: barcodeController.text.trim())
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("المنتج موجود مسبقًا")));

        return;
      }


      if (productImage != null) {
        imageUrl = await ImageService.uploadImageToImgBB(File(productImage!.path));
      
      }
      

      /// 4️⃣ حفظ المنتج
      await FirebaseFirestore.instance.collection('products').add({
        "barcode": barcodeController.text.trim(),

        "name": nameController.text.trim(),

        "category": selectedCategory,

        "imageUrl": imageUrl ?? "",

        "expirationDate": expirationController.text.trim(),

        "quantity": quantityController.text.trim(),

        "notes": notesController.text.trim(),

        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("تم حفظ المنتج بنجاح")));

      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("حدث خطأ أثناء الحفظ")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  DateTime? selectedDate;
  Future<void> pickExpirationDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;

        expirationController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.black,
                size: 26,
              ),
            ),
          ],
          centerTitle: true,
          title: const Text(
            "إضافة منتج",
            style: TextStyle(
              color: Color(0xFF0B8F4D),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// Tabs
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTab = 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedTab == 0
                                ? const Color(0xFF0B8F4D)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              "إدخال يدوي",
                              style: TextStyle(
                                color: selectedTab == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() => selectedTab = 1);
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ScannerScreen(),
                            ),
                          );
                          if (result != null) {
                            barcode = result;

                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );

                            await fetchProductByBarcode(result);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedTab == 1
                                ? const Color(0xFF0B8F4D)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              "مسح الباركود",
                              style: TextStyle(
                                color: selectedTab == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// صورة المنتج
              GestureDetector(
                onTap: _openCamera,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: productImage == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Color(0xFF0B8F4D),
                            ),
                            SizedBox(height: 10),
                            Text("إضافة صورة"),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(productImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              CustomInput(
                controller: nameController,
                label: "اسم المنتج",
                hint: "مثال: حليب كامل الدسم",
              ),
              const SizedBox(height: 18),
              CustomInput(
                controller: barcodeController,
                label: "الباركود",
                hint: "أدخل أو امسح الباركود",
              ),
              const SizedBox(height: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "الفئة",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        hint: const Text("اختر الفئة"),

                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: pickExpirationDate,
                child: AbsorbPointer(
                  child: CustomInput(
                    controller: expirationController,
                    label: "تاريخ الانتهاء",
                    hint: "اختر التاريخ",
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              CustomInput(
                controller: quantityController,
                label: "كمية / حجم",
                hint: "مثال: 1 لتر",
              ),
              const SizedBox(height: 18),
              CustomInput(
                controller: notesController,
                label: "ملاحظات (اختياري)",
                hint: "أضف ملاحظة...",
                maxLines: 4,
              ),

              const SizedBox(height: 30),

              /// زر حفظ المنتج
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B8F4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: saveProduct,
                  child: const Text(
                    "حفظ المنتج",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

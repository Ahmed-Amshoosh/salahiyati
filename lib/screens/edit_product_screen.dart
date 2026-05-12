import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiry_guard/services/image_service.dart';
import 'package:expiry_guard/widgets/customInput.dart';
import 'package:expiry_guard/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final Map product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final ImagePicker _picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController barcodeController;
  late TextEditingController expirationController;
  late TextEditingController quantityController;
  late TextEditingController notesController;

  String? selectedCategory;
  String? imageUrl;
  XFile? newImage;

  bool isLoading = false;

  final List<String> categories = [
    "ألبان",
    "مشروبات",
    "معلبات",
    "وجبات",
    "حلويات",
    "أدوية",
  ];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product['name'] ?? "");

    barcodeController = TextEditingController(
      text: widget.product['barcode'] ?? "",
    );

    expirationController = TextEditingController(
      text: widget.product['expirationDate'] ?? "",
    );

    quantityController = TextEditingController(
      text: widget.product['quantity'] ?? "",
    );

    notesController = TextEditingController(
      text: widget.product['notes'] ?? "",
    );

    selectedCategory = widget.product['category'];

    imageUrl = widget.product['imageUrl'];
  }

  Future<void> pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.camera);

    if (img != null) {
      setState(() {
        newImage = img;
      });
    }
  }

  Future<void> saveChanges() async {
    try {
      setState(() => isLoading = true);

      String finalImageUrl = imageUrl ?? "";

      /// 1️⃣ إذا المستخدم رفع صورة جديدة
      if (newImage != null) {
        final uploaded = await ImageService.uploadImageToImgBB(
          File(newImage!.path),
        );

        if (uploaded != null) {
          finalImageUrl = uploaded;
        }
      }

      /// 2️⃣ تحديث Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product['id'])
          .update({
            "name": nameController.text.trim(),
            "barcode": barcodeController.text.trim(),
            "category": selectedCategory,
            "expirationDate": expirationController.text.trim(),
            "quantity": quantityController.text.trim(),
            "notes": notesController.text.trim(),
            "imageUrl": finalImageUrl, // ✔️ الصورة الجديدة أو القديمة
          });

      if (!mounted) return;
      CustomSnackBar.success(context, "تم حفظ التعديلات بنجاح");

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("خطأ أثناء حفظ التعديلات")));
    }

    setState(() => isLoading = false);
  }

  DateTime? selectedDate;

  Future<void> pickExpirationDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
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

  Future<String?> uploadImage(File file) async {
    const apiKey = "YOUR_IMGBB_KEY";

    final url = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");

    final request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    final response = await request.send();

    final resBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final data = json.decode(resBody.body);

      return data['data']['url'];
    }

    return null;
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
            "تعديل المنتج",
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
              /// صورة المنتج
              GestureDetector(
                onTap: pickImage,

                child: Container(
                  width: 140,
                  height: 140,

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: newImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          child: Image.file(
                            File(newImage!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : imageUrl != null && imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          child: Image.network(imageUrl!, fit: BoxFit.cover),
                        )
                      : const Column(
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
                        ),
                ),
              ),

              const SizedBox(height: 25),

              /// اسم المنتج
              CustomInput(
                controller: nameController,
                label: "اسم المنتج",
                hint: "مثال: حليب كامل الدسم",
              ),

              const SizedBox(height: 18),

              /// الباركود
              CustomInput(
                controller: barcodeController,
                label: "الباركود",
                hint: "أدخل الباركود",
              ),

              const SizedBox(height: 18),

              /// الفئة
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

              /// تاريخ الانتهاء
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

              /// الكمية
              CustomInput(
                controller: quantityController,
                label: "كمية / حجم",
                hint: "مثال: 1 لتر",
              ),

              const SizedBox(height: 18),

              /// الملاحظات
              CustomInput(
                controller: notesController,
                label: "ملاحظات (اختياري)",
                hint: "أضف ملاحظة...",
                maxLines: 4,
              ),

              const SizedBox(height: 30),

              /// زر الحفظ
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

                  onPressed: isLoading ? null : saveChanges,

                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "حفظ التعديلات",
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

import 'package:expiry_guard/screens/scanner_screen.dart';
import 'package:expiry_guard/widgets/customInput.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  int selectedTab = 0; // 0 = scan, 1 = manual

  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      debugPrint("Image path: ${image.path}");
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
              /// 🔥 Tabs
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

                    /// مسح الباركود
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

                          // بعد الرجوع من المسح
                          if (result != null) {
                            debugPrint("Barcode: $result");
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

                    /// إدخال يدوي
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// 📸 صورة المنتج
              GestureDetector(
                onTap: _openCamera,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
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

              const CustomInput(
                label: "اسم المنتج",
                hint: "مثال: حليب كامل الدسم",
              ),

              const SizedBox(height: 18),

              const CustomInput(
                label: "الفئة",
                hint: "اختر الفئة",
                icon: Icons.keyboard_arrow_down,
              ),

              const SizedBox(height: 18),

              const CustomInput(
                label: "تاريخ الانتهاء",
                hint: "اختر التاريخ",
                icon: Icons.calendar_today_outlined,
              ),

              const SizedBox(height: 18),

              const CustomInput(label: "كمية / حجم", hint: "مثال: 1 لتر"),

              const SizedBox(height: 18),

              const CustomInput(
                label: "ملاحظات (اختياري)",
                hint: "أضف ملاحظة...",
                maxLines: 4,
              ),

              const SizedBox(height: 30),

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

                  onPressed: () {},

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

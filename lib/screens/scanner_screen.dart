import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'product_details.dart';
import 'productNot_found_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with TickerProviderStateMixin {
  bool isDetected = false;
  bool isFlashOn = false;

  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;

  final MobileScannerController _cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();

    /// 🔴 حركة خط المسح
    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _scanAnimation = Tween<double>(begin: 0, end: 220).animate(
      CurvedAnimation(
        parent: _scanAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          /// 📸 الكاميرا
          MobileScanner(
            controller: _cameraController,

            onDetect: (capture) async {
              if (isProcessing) return;

              final barcodes = capture.barcodes;

              if (barcodes.isEmpty) return;

              final code = barcodes.first.rawValue;

              if (code == null) return;

              final cleaned = code.trim();

              if (cleaned.length < 8) return;

              isProcessing = true;

              isDetected = true;

              await _cameraController.stop();

              await Future.delayed(const Duration(milliseconds: 200));

              if (mounted) {
                Navigator.pop(context, cleaned);
              }
            },
          ),

          /// Loader
          if (isProcessing)
            Container(
              color: Colors.black54,

              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    CircularProgressIndicator(color: Colors.white),

                    SizedBox(height: 20),

                    Text(
                      "جاري قراءة الباركود...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          /// 🔲 طبقة تغميق
          Container(color: Colors.black.withOpacity(0.45)),

          /// ✨ واجهة الصفحة
          SafeArea(
            child: Column(
              children: [
                /// 🔝 AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      /// رجوع
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      /// عنوان
                      const Text(
                        "مسح الباركود",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),

                      /// فلاش
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: IconButton(
                          icon: Icon(
                            isFlashOn
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isFlashOn = !isFlashOn;
                              _cameraController.toggleTorch();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// 🎯 إطار المسح
                Stack(
                  alignment: Alignment.center,

                  children: [
                    /// Glow خارجي
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0B8F4D).withOpacity(0.35),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),

                    /// البوكس الأساسي
                    Container(
                      width: 260,
                      height: 260,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),

                        border: Border.all(
                          color: const Color(0xFF0B8F4D),
                          width: 3,
                        ),
                      ),
                    ),

                    /// ✨ الزوايا الاحترافية
                    Positioned(top: 0, left: 0, child: _buildCorner()),

                    Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.rotate(
                        angle: 1.57,
                        child: _buildCorner(),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Transform.rotate(
                        angle: -1.57,
                        child: _buildCorner(),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Transform.rotate(
                        angle: 3.14,
                        child: _buildCorner(),
                      ),
                    ),

                    /// 🔴 خط المسح المتحرك
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: _scanAnimation.value + 20,
                          left: 25,
                          right: 25,

                          child: Container(
                            height: 4,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                              gradient: const LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.redAccent,
                                  Colors.transparent,
                                ],
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.8),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                /// النص
                const Text(
                  "وجه الكاميرا نحو الباركود",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "سيتم التعرف على المنتج تلقائياً",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15,
                  ),
                ),

                const Spacer(),

                /// أيقونة صور
                Container(
                  margin: const EdgeInsets.only(bottom: 35),
                  width: 62,
                  height: 62,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: const Icon(
                    Icons.image_rounded,
                    size: 30,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 📦 بعد المسح
  void _onScan(String code) async{
    Future.delayed(const Duration(milliseconds: 500), () async{
await _cameraController.stop();

final snapshot = await FirebaseFirestore.instance
    .collection('products')
    .where('barcode', isEqualTo: code)
    .limit(1)
    .get();

if (!mounted) return;

if (snapshot.docs.isNotEmpty) {
  final product = snapshot.docs.first.data();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => ProductDetailsScreen(product: product),
    ),
  );
} else {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const ProductNotFoundScreen(),
    ),
  );
}    });
  }

  Widget _buildCorner() {
    return Container(
      width: 40,
      height: 40,

      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF0B8F4D), width: 5),

          left: BorderSide(color: Color(0xFF0B8F4D), width: 5),
        ),
      ),
    );
  }
}

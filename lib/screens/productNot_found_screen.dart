import 'package:flutter/material.dart';

class ProductNotFoundScreen extends StatelessWidget {
  const ProductNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: const [
            Icon(Icons.error_outline, size: 90, color: Colors.red),

            SizedBox(height: 20),

            Text(
              "المنتج غير موجود",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "لم يتم العثور على هذا الباركود",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
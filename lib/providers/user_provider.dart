import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String name = "";
  String email = "";
  String image = "";

  /// 🔥 تحميل البيانات أول مرة
  Future<void> loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((doc) {
      final data = doc.data();

      name = data?['name'] ?? "";
      email = data?['email'] ?? "";
      image = data?['image'] ?? "";

      notifyListeners(); // 🔥 تحديث كل التطبيق
    });
  }
}
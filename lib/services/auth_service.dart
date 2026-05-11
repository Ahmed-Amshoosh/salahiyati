import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إنشاء حساب
  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      /// حفظ بيانات المستخدم
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "name": name,
        "email": email,
        "createdAt": DateTime.now(),
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "حدث خطأ";
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        signInOption: SignInOption.standard,
      );

      // 🔥 مهم: تسجيل خروج من Google قبل الدخول (لتجنب اختيار الحساب القديم)
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final user = userCredential.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "name": user.displayName ?? "مستخدم",
          "email": user.email,
          "photo": user.photoURL,
          "createdAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return user;
    } catch (e) {
      throw "فشل تسجيل الدخول عبر Google";
    }
  }

  /// تسجيل الدخول
  Future<User?> login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw FirebaseAuthException(
            code: e.code,
            message: "المستخدم غير موجود",
          );

        case 'wrong-password':
          throw FirebaseAuthException(
            code: e.code,
            message: "كلمة المرور غير صحيحة",
          );

        default:
          throw FirebaseAuthException(code: e.code, message: "حدث خطأ");
      }
    }
  }

  /// تسجيل خروج
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut(); // تسجيل خروج Google
      await FirebaseAuth.instance.signOut(); // تسجيل خروج Firebase
    } catch (e) {
      throw "فشل تسجيل الخروج";
    }
  }
}

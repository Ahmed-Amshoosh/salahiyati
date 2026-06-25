import 'package:expiry_guard/screens/forgot_password_screen.dart';
import 'package:expiry_guard/screens/home_screen.dart';
import 'package:expiry_guard/screens/register_screen.dart';
import 'package:expiry_guard/services/auth_service.dart';
import 'package:expiry_guard/widgets/custom_snackbar.dart';
import 'package:expiry_guard/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  static Widget _socialButton(IconData icon, Color color) {
    return Container(
      width: 55,
      height: 55,

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        shape: BoxShape.circle,
        color: Colors.white,
      ),

      child: Center(child: Icon(icon, color: color, size: 40)),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// زر الرجوع
                      const SizedBox(height: 10),

                      /// الشعار
                      Center(
                        child: Image.asset(
                          "assets/images/logo2.png",
                          width: 120,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// العنوان
                      const Center(
                        child: Text(
                          "👋 مرحباً بعودتك",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B8F4D),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// الوصف
                      const Center(
                        child: Text(
                          "سجل دخولك لمتابعة منتجاتك",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// البريد الإلكتروني
                      CustomTextField(
                        controller: emailController,
                        hint: "example@email.com",
                        label: "البريد الإلكتروني",
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 20),

                      /// كلمة المرور
                      CustomTextField(
                        hint: "********",
                        controller: passwordController,
                        label: "كلمة المرور",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 12),

                      /// نسيت كلمة المرور
                      Align(
                        alignment: Alignment.centerRight,

                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },

                          child: const Text(
                            "نسيت كلمة المرور؟",
                            style: TextStyle(
                              color: Color(0xFF0B8F4D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// زر تسجيل الدخول
                      SizedBox( width: double.infinity, height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom( backgroundColor: const Color(0xFF0B8F4D),
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(14),),),
                          onPressed: () async {
                            if (emailController.text.isEmpty ||  passwordController.text.isEmpty) {
                              CustomSnackBar.error(  context, "يرجى تعبئة جميع الحقول", );
                              return;
                            }
                            try {
                              setState(() {  isLoading = true; });
                              await authService.login(  email: emailController.text.trim(), password: passwordController.text.trim(), );
                              if (context.mounted) {
                                Navigator.pushReplacement(  context, MaterialPageRoute( builder: (_) => HomeScreen()),);
                              }
                            } on FirebaseAuthException catch (e) {
                              String message;
                              switch (e.code) {
                                case 'user-not-found': message =  "لا يوجد مستخدم بهذا البريد الإلكتروني";  break;
                                case 'wrong-password': message = "كلمة المرور غير صحيحة"; break;
                                case 'invalid-email': message = "البريد الإلكتروني غير صالح";  break;
                                case 'user-disabled':  message = "هذا الحساب تم تعطيله";  break;
                                case 'too-many-requests': message = "محاولات كثيرة، حاول لاحقًا"; break;
                                case 'invalid-credential':  message = "بيانات الدخول غير صحيحة أو منتهية";  break;
                                default:  message = "حدث خطأ غير متوقع";
                              }
                              CustomSnackBar.error(context, message);
                            } finally {
                              setState(() { isLoading = false; });
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white, )
                              : const Text( "تسجيل الدخول", style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white, ), ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// أو
                      Row(
                        children: const [
                          Expanded(child: Divider()),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "او",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// تسجيل عبر الحسابات قوقل
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              try {
                                setState(() => isLoading = true);

                                final user = await authService
                                    .signInWithGoogle();

                                if (user != null && context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HomeScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                CustomSnackBar.error(context, e.toString());
                              } finally {
                                setState(() => isLoading = false);
                              }
                            },
                            child: LoginScreen._socialButton(
                              Icons.g_mobiledata,
                              Colors.red,
                            ),
                          ),

                          LoginScreen._socialButton(Icons.apple, Colors.black),

                          LoginScreen._socialButton(
                            Icons.facebook,
                            const Color.fromARGB(255, 0, 102, 254),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      /// إنشاء حساب
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Text(
                              "ليس لديك حساب؟",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },

                              child: const Text(
                                "إنشاء حساب",
                                style: TextStyle(
                                  color: Color(0xFF0B8F4D),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// COMPONENT للحقل

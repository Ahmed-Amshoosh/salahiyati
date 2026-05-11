import 'package:expiry_guard/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  final emailController = TextEditingController();
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
                        size: 22,
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
                          "نسيت كلمة المرور؟",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B8F4D),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// وصف
                      const Center(
                        child: Text(
                          "أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// الإيميل
                       CustomTextField(
                        controller: emailController,
                        hint: "example@email.com",
                        label: "البريد الإلكتروني",
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 30),
                      Center(
                        child: const Text(
                          "سنرسل لك رابط لإعادة تعيين كلمة المرور",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),

                      /// زر الإرسال
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
                            "إرسال الرابط",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Text(
                              "تذكر كلمة المرور؟",
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
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },

                              child: const Text(
                                "تسجيل الدخول",
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

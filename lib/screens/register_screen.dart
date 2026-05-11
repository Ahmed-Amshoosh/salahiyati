import 'package:expiry_guard/screens/home_screen.dart';
import 'package:expiry_guard/services/auth_service.dart';
import 'package:expiry_guard/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final erpatPasswordController = TextEditingController();

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
                          "إنشاء حساب جديد",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B8F4D),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Center(
                        child: Text(
                          "أنشئ حسابك وابدأ باستخدام التطبيق",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// الاسم
                      CustomTextField(
                        controller: nameController,
                        hint: "محمد أحمد",
                        label: "الاسم الكامل",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 20),

                      /// الإيميل
                      CustomTextField(
                        controller: emailController,
                        hint: "example@email.com",
                        label: "البريد الإلكتروني",
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 20),

                      /// كلمة المرور
                      CustomTextField(
                        controller: passwordController,
                        hint: "********",
                        label: "كلمة المرور",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 20),

                      /// تأكيد كلمة المرور
                      CustomTextField(
                        controller: erpatPasswordController,
                        hint: "********",
                        label: "تأكيد كلمة المرور",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 35),
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            activeColor: const Color(0xFF0B8F4D),
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),

                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),

                                children: [
                                  TextSpan(
                                    text: "أوافق على ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  TextSpan(
                                    text: "الشروط والأحكام",
                                    style: TextStyle(
                                      color: Color(0xFF0B8F4D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  TextSpan(text: " و "),

                                  TextSpan(
                                    text: "سياسة الخصوصية",
                                    style: TextStyle(
                                      color: Color(0xFF0B8F4D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// زر إنشاء الحساب
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

                          onPressed: () async {
                            /// التحقق من الحقول
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                erpatPasswordController.text.isEmpty) {
                              CustomSnackBar.error(
                                context,
                                "يرجى تعبئة جميع الحقول",
                              );

                              return;
                            }

                            /// التحقق من تطابق كلمة المرور
                            if (passwordController.text !=
                                erpatPasswordController.text) {
                              CustomSnackBar.error(
                                context,
                                "كلمتا المرور غير متطابقتين",
                              );

                              return;
                            }

                            /// التحقق من الموافقة
                            if (!isChecked) {
                              CustomSnackBar.error(
                                context,
                                "يجب الموافقة على الشروط والأحكام",
                              );

                              return;
                            }

                            try {
                              setState(() {
                                isLoading = true;
                              });

                              /// إنشاء الحساب
                              await authService.register(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                              /// رسالة نجاح
                              if (context.mounted) {
                                CustomSnackBar.success(
                                  context,
                                  "تم إنشاء الحساب بنجاح 🎉",
                                );

                                /// انتظار بسيط
                                await Future.delayed(
                                  const Duration(seconds: 1),
                                );

                                /// الانتقال للرئيسية
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>  HomeScreen(),
                                  ),
                                );
                              }
                            } catch (e) {
                              CustomSnackBar.error(context, e.toString());
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "إنشاء حساب",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// تسجيل دخول
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Text(
                              "لديك حساب بالفعل؟",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: const Text(
                                "تسجيل الدخول",
                                style: TextStyle(
                                  color: Color(0xFF0B8F4D),
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

import 'package:expiry_guard/firebase_options.dart';
import 'package:expiry_guard/providers/user_provider.dart';
import 'package:expiry_guard/screens/home_screen.dart';
import 'package:expiry_guard/screens/login_screen.dart';
import 'package:expiry_guard/screens/onboarding/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('onboarding_done') ?? false;


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()..loadUser(),
        ),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  MyApp({super.key, required this.seenOnboarding});
  final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Expiry Guard',

      theme: ThemeData(
        primaryColor: const Color(0xFF0B8F4D),

        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B8F4D)),

        textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),

      home: isLoggedIn
          ? HomeScreen()
          : seenOnboarding
          ? const LoginScreen()
          : const OnboardingScreen(),
    );
  }
}

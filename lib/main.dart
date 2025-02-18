import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nomnom_passport_223841m_cpmad_project/screens/about_page.dart';
import 'package:nomnom_passport_223841m_cpmad_project/screens/addpost_page.dart';
import 'package:nomnom_passport_223841m_cpmad_project/screens/contactus_page.dart';

import 'package:nomnom_passport_223841m_cpmad_project/screens/navigation_page.dart';
import 'package:nomnom_passport_223841m_cpmad_project/screens/nomnomJourneystart_page.dart';
import 'package:nomnom_passport_223841m_cpmad_project/screens/search_page.dart';

import 'firebase_options.dart';
import 'screens/login_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // try {
    await Firebase.initializeApp(options: 
    DefaultFirebaseOptions.currentPlatform);
  // } catch (e) {
  //   print("Error initializing Firebase: $e");
  // }
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NomNom Passport+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PT Sans', // Set PT Sans as the default font
        primaryColor: const Color(0xFFFDB67D),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFDB67D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home':(context) => NavigationPage(),
        '/contactus':(context) => const ContactUsPage(),
        '/about':(context) => const AboutPage(),
        '/nomnomjourney':(context) => NomNomScreen(isFromHomepage: false),
        '/search':(context) => SearchPage(),
        '/addPost':(context) => AddPostPage(),
      },
      home: NavigationPage(),
    );
  }
}

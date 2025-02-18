import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_page.dart';
import 'nomnomJourney_page.dart';

class NomNomScreen extends StatelessWidget {
  final bool isFromHomepage; // Flag to check if accessed from homepage

  const NomNomScreen({super.key, required this.isFromHomepage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isFromHomepage, // Show back button only if accessed from homepage
        title: const Text("My NOM NOM Journey"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Handle history button press
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF5F5F5),
                  Color(0xFFFFE3BF),
                ],
              ),
            ),
          ),
          Image.asset(
            'images/map.png',
            fit: BoxFit.fitWidth,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo.png',
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Plan your Tasty Adventures",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        Get.to(() => const LoginPage()); // Redirect to LoginPage if not logged in
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NomNomJourney()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text("Start"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

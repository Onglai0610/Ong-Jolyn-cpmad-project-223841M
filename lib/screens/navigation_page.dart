// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addpost_page.dart';
import '../controllers/navigation_controller.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'nomnomJourneystart_page.dart';
import 'profile_page.dart';
// import 'restaurant_test.dart';
import 'search_page.dart';
// import 'search_page.dart';
// import 'addpost_page.dart';

class NavigationPage extends StatelessWidget {
  final NavigationController navigationController = Get.put(NavigationController());

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    AddPostPage(), 
    NomNomScreen(isFromHomepage: false),
  ];

  Future<void> _handleProfileNavigation() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Navigate to LoginPage if not logged in
      await Get.to(() => const LoginPage());
    } else {
      // Add ProfilePage dynamically if logged in
      _pages.add(ProfilePage());
      navigationController.changePage(4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        int index = navigationController.selectedIndex.value;
        if (index == 4 && _pages.length <= 4) {
          return Container(); // Show empty container
        }
        return _pages[index];
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'New Post',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('images/icons/passport.png'),
                size: 25, 
              ),
              label: 'Passport',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: navigationController.selectedIndex.value,
          selectedItemColor: Color(0xFFFEB57E),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 4) {
              _handleProfileNavigation();
            } else if (index == 2) { // Check for AddPostPage
              User? user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              Get.to(() => const LoginPage()); // Redirect to LoginPage
            } else {
              navigationController.changePage(index); // Allow navigation if logged in
            }
          } else {
            navigationController.changePage(index);
          }
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              _controller.signOut();
            },
          ),
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFE3BF),
                  Color(0xFFF5F5F5),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hello ${_controller.username.value}!",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 70, 70, 70)
                      ),
                    ),

                    const SizedBox(height: 20),

                    // White Container with Rounded Corners (User Information)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, size: 50, color: Colors.orange),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Username TextField
                          SizedBox(
                            height: 40,
                            child: TextField(
                              controller: TextEditingController(text: _controller.username.value),
                              onChanged: (value) {
                                _controller.username.value = value;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: "Username",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Email TextField (Disabled)
                          SizedBox(
                            height: 40,
                            child: TextField(
                              controller: TextEditingController(text: _controller.email.value),
                              readOnly: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Update Button
                          ElevatedButton(
                            onPressed: () {
                              _controller.updateProfile(_controller.username.value);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Update",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Additional Information Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Additional Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          ElevatedButton(
                            onPressed: () {
                               Navigator.of(context).pushNamed('/about');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "About Nom Nom Passport+",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Contact Us Button with '>' Icon
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/contactus');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Contact Us",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.white,
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
      }),
    );
  }
}

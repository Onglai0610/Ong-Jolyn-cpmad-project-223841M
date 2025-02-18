import 'package:flutter/material.dart';
// import 'home_page.dart';
import '../services/firebaseauth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'navigation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool signUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushNamed('/home');
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset("images/logo.png",
                        height: 150, 
                        width: 150, 
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (signUp) // Username and Confirm Password fields only for sign-up
                      const Text("Sign Up",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    if(!signUp)
                      const Text("Sign In",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 20),
                    if (signUp) // Username and Confirm Password fields only for sign-up
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, // Adjust height
                              horizontal: 10, // Adjust padding inside the text field
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, // Adjust height
                              horizontal: 10, // Adjust padding inside the text field
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, // Adjust height
                              horizontal: 10, // Adjust padding inside the text field
                            ),
                        ),
                      ),
                    ),
                    if (signUp) // Confirm Password field for sign-up only
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, // Adjust height
                              horizontal: 10, // Adjust padding inside the text field
                            ),
                          ),
                        ),
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDB67D), // Button color
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Button border radius
                        ),
                      ),
                      onPressed: () async {
                        if (signUp) {
                          // Check if passwords match
                          if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Passwords do not match')),
                            );
                            return;
                          }
                          // Sign-up logic
                          var newUser = await FirebaseAuthService().signUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            username: usernameController.text.trim()
                          );
                          if (newUser != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(newUser.uid)
                                .set({
                              'email': emailController.text.trim(),
                              'username': usernameController.text.trim(),
                              'createdAt': FieldValue.serverTimestamp(),
                            });
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => NavigationPage(),
                              ),
                            );
                          }
                        } else {
                          // Sign-in logic
                          var regUser = await FirebaseAuthService().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                          if (regUser != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => NavigationPage(),
                              ),
                            );
                          }
                        }
                      },
                      child: signUp ? const Text('Sign Up') : const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    signUp = !signUp;
                  });
                },
                child: signUp
                    ? const Text('Have an account? Sign In')
                    : const Text('Have an existing account? Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

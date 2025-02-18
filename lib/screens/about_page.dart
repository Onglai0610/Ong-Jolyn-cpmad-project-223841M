import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'About',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [

                    Image.asset(
                      'images/logo.png', 
                      height: 80,
                    ),
                    const SizedBox(height: 16),
                    // Title
                    const Text(
                      'Nom Nom Passport+',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Description
                    const Text(
                      'NomNom Passport+ is a smart dining app designed to enhance your culinary journey in Singapore. '
                      'Whether you’re a foodie exploring diverse cuisines or someone seeking allergy-safe dining options, '
                      'our app ensures an inclusive, rewarding, and safe dining experience.',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                    // About the Company
                    const Text(
                      'About the Company',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'NomNom Solutions is dedicated to leveraging technology to create meaningful food experiences. '
                      'By combining convenience, safety, and community engagement, we aim to transform the way people dine and discover food.',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // About the Developer Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'About the Developer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This application was developed by Ong Jolyn as part of the CPMAD L2 project initiative under the theme '
                      '“My Smart City: Connecting Our Senses.” The project emphasizes enhancing convenience and connectivity in '
                      'Singapore’s vibrant food and beverage sector.',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

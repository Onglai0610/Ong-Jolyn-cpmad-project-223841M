import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen to set the container width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Contact Us',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
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
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Help Desk Information Header
                const Text(
                  'For assistance, you can reach us through the following methods:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Help Desk Phone Number Container
                SizedBox(
                  width: screenWidth * 0.9,
                  child: Container(
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
                        const Icon(
                          Icons.phone_in_talk,
                          size: 50,
                          color: Colors.orange,
                        ),
                        const Text(
                          'Help Desk',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final Uri phoneUri = Uri(scheme: 'tel', path: '18002311341');
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            } else {
                              throw 'Could not launch $phoneUri';
                            }
                          },
                          child: const Text(
                            '1800 231 1341',
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Colors.blue, // Make it look like a link
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Operating Hours: Monday - Friday, 9am - 4pm',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Help Desk Email Container
                SizedBox(
                  width: screenWidth * 0.9,
                  child: Container(
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
                        const Icon(
                          Icons.email,
                          size: 50,
                          color: Colors.orange,
                        ),
                        const Text(
                          'Email',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final Uri emailUri = Uri(
                              scheme: 'mailto',
                              path: 'help@nomnom.sg',
                              query: 'subject=Assistance Request',
                            );
                            if (await canLaunchUrl(emailUri)) {
                              await launchUrl(emailUri);
                            } else {
                              throw 'Could not launch $emailUri';
                            }
                          },
                          child: const Text(
                            'help@nomnom.sg',
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Colors.blue, // Make it look like a link
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'We will respond to your enquiry within 3 working days.',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Urgent Assistance Information
                const Text(
                  'For urgent assistance, please call the Help-Desk.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

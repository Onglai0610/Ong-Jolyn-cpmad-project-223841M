import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/stamp_controller.dart';
import 'nomnomJourneystart_page.dart';

class HomePage extends StatelessWidget {
  final StampController stampController = Get.put(StampController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    stampController.fetchStampCount();
    stampController.fetchSavedCuisineCount();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
            child: ListView(
              children: [
                const Text(
                  'NOM NOM Passport+',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Search bar with filter button
                // Row(
                //   children: [
                //     Expanded(
                //       flex: 7,
                //       child: SizedBox(
                //         height: 35,
                //         child: TextField(
                //           style: const TextStyle(fontSize: 20),
                //           decoration: InputDecoration(
                //             hintText: 'Search by cuisine or restaurant',
                //             hintStyle: const TextStyle(fontSize: 15),
                //             filled: true,
                //             fillColor: Colors.white,
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(20),
                //               borderSide: BorderSide.none,
                //             ),
                //             suffixIcon: const Icon(Icons.search),
                //             contentPadding: const EdgeInsets.symmetric(
                //               vertical: 15, horizontal: 10,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     SizedBox(
                //       width: 50,
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.white,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //           padding: const EdgeInsets.all(5),
                //         ),
                //         child: Image.asset(
                //           "images/icons/fliter.png",
                //           height: 20, width: 20,
                //           fit: BoxFit.contain,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                const SizedBox(height: 20),
                // Stamps & Saved Cuisines Section
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => _buildStatColumn(
                        context, "images/icons/stamp.png",
                        "${stampController.stampCount.value}", "Get more stamps >")),
                      const SizedBox(
                        height: 50,
                        child: VerticalDivider(color: Colors.grey, thickness: 1),
                      ),
                      Obx(() => _buildStatColumn(
                        context, "images/icons/saved.png",
                        "${stampController.savedCuisineCount.value}", "View saved cuisines >")),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tagline
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Explore Safely,\nReward Deliciously',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Plan Your Nom Nom Journey Button
                Center(
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/nomnomjourney');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Plan Your Nom Nom Journey",
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(Icons.arrow_right, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Today's Highlight Section with Carousel
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Highlight",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 150,
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                        ),
                        items: [
                          _buildCarouselItem("images/Boon Tong Kee.png", "Earn 2 Stamps when you dine at Boon Tong Kee this week!"),
                          _buildCarouselItem("images/Changi Village Fried Hokkien Mee.png", "Earn 2 Stamps when you dine at Changi Village Fried Hokkien Mee this month!"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Posts Section
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No posts available"));
                      }
                      var posts = snapshot.data!.docs;
                      return GridView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          var post = posts[index].data() as Map<String, dynamic>?;
                          return post != null ? _buildPostItem(post) : const SizedBox();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String iconPath, String count, String actionText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Image.asset(iconPath, height: 30, width: 30),
            const SizedBox(width: 5),
            Text(
              count,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
          child: TextButton(
            onPressed: () {
              if (actionText == "Get more stamps >") {
                Navigator.of(context).pushNamed('/addPost');
              } else if (actionText == "View saved cuisines >") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NomNomScreen(isFromHomepage: true),
                    ),
                );
              }
            },
            child: Text(
              actionText,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(String image, String caption) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              caption,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Image.network(
            post['imageUrls']?[0] ?? '',
            width: double.infinity,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, size: 50),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['title'] ?? 'No Title',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5), // Space between title and username
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(post['uid']) // Use the 'uid' from the post to query the users collection
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('Unknown User');
                  }
                  var user = snapshot.data!;
                  String username = user['username'] ?? 'Unknown User'; // Assuming the username field exists
                  return Text(
                    'Posted by $username',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


}

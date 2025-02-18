import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import 'cusineInformation_page.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final SearchRestaurantController searchRestaurantController = Get.put(SearchRestaurantController());

  @override
  Widget build(BuildContext context) {

    final bool fromNomNomJourney = Get.arguments?['fromNomNomJourney'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: fromNomNomJourney, // Show back button only if accessed from NomNomJourney
      ),
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (query) => searchRestaurantController.searchRestaurants(query),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Search by cuisine or restaurant',
                      hintStyle: const TextStyle(fontSize: 15),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Restaurant List
                Expanded(
                  child: Obx(() {
                    if (searchRestaurantController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (searchRestaurantController.filteredRestaurants.isEmpty) {
                      return const Center(child: Text("No restaurants found"));
                    }

                    return ListView.builder(
                      itemCount: searchRestaurantController.filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        var restaurant = searchRestaurantController.filteredRestaurants[index];
                        String restaurantId = restaurant['id'];

                        return FutureBuilder<List<dynamic>>(
                          future: Future.wait([
                            searchRestaurantController.getImageUrl(restaurantId),
                            searchRestaurantController.getOutletAddresses(restaurantId), // Fetch addresses
                          ]),
                          builder: (context, snapshot) {
                            String imageUrl = snapshot.data?[0] ?? '';
                            List<String> outletAddresses = snapshot.data?[1] ?? [];

                            return _buildRestaurantCard(
                              restaurantId: restaurantId,
                              restaurantName: restaurant['restaurantName'],
                              cuisine: restaurant['cusineName'],
                              description: restaurant['description'],
                              rating: restaurant['rating'],
                              rewards: restaurant['rewards'],
                              imageUrl: imageUrl,
                              outletAddresses: outletAddresses,
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the restaurant card UI
  Widget _buildRestaurantCard({

    required String restaurantId,
    required String restaurantName,
    required String cuisine,
    required String description,
    required double rating,
    required String rewards,
    required String imageUrl,
    required List<String> outletAddresses,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CuisineInformationPage(
          restaurantId: restaurantId,
          restaurantName: restaurantName,
          cuisine: cuisine,
          description: description,
          rating: rating,
          rewards: rewards,
          imageUrl: imageUrl,
          outletAddresses: outletAddresses, // Pass addresses
        ));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_rounded, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurantName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(cuisine),
                  Row(children: [Text("$rating/5"), const Icon(Icons.star, size: 16, color: Colors.yellow)]),
                  const SizedBox(height: 10),
                  Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text(rewards, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 10),
                  Text("${outletAddresses.length} Outlets", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

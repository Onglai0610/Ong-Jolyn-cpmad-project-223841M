import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class SearchRestaurantController extends GetxController {
  var restaurants = <Map<String, dynamic>>[].obs;
  var filteredRestaurants = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  /// Fetch restaurants from Firestore
  Future<void> fetchRestaurants() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('restaurants').get();
      
      List<Map<String, dynamic>> restaurantList = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,  // Use document ID as restaurant ID
          'restaurantName': data['restaurantName'] ?? 'Unknown',
          'cusineName': data['cusineName'] ?? 'Cuisine not available',
          'description': data['description'] ?? '',
          'rating': data['rating']?.toDouble() ?? 0,
          'rewards': data['rewards'] ?? '',
        };
      }).toList();

      restaurants.assignAll(restaurantList);
      filteredRestaurants.assignAll(restaurantList);
      isLoading.value = false;
    } catch (e) {
      print("Error fetching restaurants: $e");
      isLoading.value = false;
    }
  }

  /// Fetch the restaurant image URL from Firebase Storage
  Future<String> getImageUrl(String restaurantId) async {
    try {
      return await FirebaseStorage.instance.ref('restaurants/$restaurantId.png').getDownloadURL();
    } catch (e) {
      print("Image not found for Restaurant ID: $restaurantId");
      return '';
    }
  }

  /// Fetch the number of outlets for a restaurant
  Future<int> getOutletsCount(String restaurantId) async {
    try {
      QuerySnapshot outletsSnapshot = await FirebaseFirestore.instance
          .collection('outlets')
          .where('restaurant', isEqualTo: restaurantId)
          .get();

      int count = outletsSnapshot.docs.length;
      print("Restaurant ID: $restaurantId has $count outlets");
      return count;
    } catch (e) {
      print("Error fetching outlets for Restaurant ID: $restaurantId: $e");
      return 0;
    }
  }

  /// Fetch the outlet addresses for a restaurant
  Future<List<String>> getOutletAddresses(String restaurantId) async {
    try {
      QuerySnapshot outletsSnapshot = await FirebaseFirestore.instance
          .collection('outlets')
          .where('restaurant', isEqualTo: restaurantId)
          .get();

      return outletsSnapshot.docs.map((doc) => doc['address'].toString()).toList();
    } catch (e) {
      print(" Error fetching outlet addresses for Restaurant ID: $restaurantId: $e");
      return [];
    }
  }

  /// Search restaurants by name or cuisine
  void searchRestaurants(String query) {
    searchQuery.value = query.toLowerCase();
    if (query.isEmpty) {
      filteredRestaurants.assignAll(restaurants);
    } else {
      filteredRestaurants.assignAll(
        restaurants.where((restaurant) {
          return restaurant['restaurantName'].toLowerCase().contains(searchQuery.value) ||
                 restaurant['cusineName'].toLowerCase().contains(searchQuery.value);
        }).toList(),
      );
    }
  }

}

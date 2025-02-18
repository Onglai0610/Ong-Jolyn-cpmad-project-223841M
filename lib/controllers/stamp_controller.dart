import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StampController extends GetxController {
  var stampCount = 0.obs;
  var savedCuisineCount = 0.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchStampCount();
    fetchSavedCuisineCount();
  }

  Future<void> fetchStampCount() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot stampDoc = await _firestore.collection('stamps').doc(user.uid).get();

      if (stampDoc.exists) {
        stampCount.value = stampDoc['stampCount'] ?? 0;
      }
    }
  }

  void fetchSavedCuisineCount() async {
  try {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    var savedDoc = await _firestore.collection('saved').doc(userId).get();

    if (savedDoc.exists) {
      print("Document Data: ${savedDoc.data()}"); // Debug: print the document data

      // Get the document data as a map.  No need to access a 'cuisines' field.
      Map<String, dynamic> savedData = savedDoc.data() as Map<String, dynamic>; // Type cast is IMPORTANT
      print("Saved Data Map: $savedData"); // Debug: print the saved data map

      // The keys of this map are your cuisine IDs.
      savedCuisineCount.value = savedData.length; // Directly count the keys

    } else {
      savedCuisineCount.value = 0; // No saved cuisines
    }
  } catch (e) {
    print("Error fetching saved cuisine count: $e");
  }
}




}

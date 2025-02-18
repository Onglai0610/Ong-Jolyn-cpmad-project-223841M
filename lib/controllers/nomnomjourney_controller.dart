import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class NomNomController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var noteController = "".obs;
  var notesList = <String>[].obs;
  var showSaveButton = false.obs;

  RxList<Map<String, dynamic>> savedRestaurants = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNote();
    fetchSavedNotes();
    fetchSavedRestaurants();
  }

  void onNoteChanged(String value) {
    noteController.value = value;
    showSaveButton.value = true;
  }

  Future<void> loadNote() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('notes').doc(user.uid).get();
      if (doc.exists) {
        noteController.value = doc['note'] ?? "";
      }
    }
  }

  Future<void> saveNote() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('notes').doc(user.uid).set({
        'uid': user.uid,
        'note': noteController.value,
      }, SetOptions(merge: true));

      Fluttertoast.showToast(msg: "Note saved successfully!");
      showSaveButton.value = false;
      fetchSavedNotes();
    }
  }

  Future<void> fetchSavedNotes() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _firestore.collection('notes').where('uid', isEqualTo: user.uid).get();
      notesList.value = snapshot.docs.map((doc) => doc['note'].toString()).toList();
    }
  }

  Future<void> fetchSavedRestaurants() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot docSnapshot = await _firestore.collection('saved').doc(user.uid).get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          List<Map<String, dynamic>> restaurantList = [];

          for (var entry in data.entries) {
            if (entry.value is Map<String, dynamic>) {
              String restaurantId = entry.key;

              try {
                DocumentSnapshot restaurantDoc = await _firestore.collection('restaurants').doc(restaurantId).get();
                if (restaurantDoc.exists) {
                  var restaurantDetails = restaurantDoc.data() as Map<String, dynamic>?;

                  if (restaurantDetails != null) {
                    List<String> outletAddresses = await getOutletAddresses(restaurantId);

                    restaurantList.add({
                      'restaurantId': restaurantId,
                      'restaurantName': restaurantDetails['restaurantName'] ?? '',
                      'cusineName': restaurantDetails['cusineName'] ?? '',
                      'imageUrl': restaurantDetails['imageUrl'] ?? _generateImageUrl(restaurantId),
                      'rating': (restaurantDetails['rating'] is int)
                          ? (restaurantDetails['rating'] as int).toDouble()
                          : (restaurantDetails['rating'] as double?) ?? 0.0,
                      'rewards': restaurantDetails['rewards'] ?? '',
                      'description': restaurantDetails['description'] ?? '',
                      'outletAddresses': outletAddresses,
                    });
                  }
                }
              } catch (e) {
                print("Error fetching restaurant details for ID: $restaurantId - $e");
              }
            }
          }

          savedRestaurants.value = restaurantList;
        }
      }
    }
  }

  Future<List<String>> getOutletAddresses(String restaurantId) async {
    try {
      QuerySnapshot outletsSnapshot = await _firestore
          .collection('outlets')
          .where('restaurant', isEqualTo: restaurantId)
          .get();

      return outletsSnapshot.docs.map((doc) => doc['address'].toString()).toList();
    } catch (e) {
      print("Error fetching outlet addresses for Restaurant ID: $restaurantId: $e");
      return [];
    }
  }

  String _generateImageUrl(String restaurantId) {
    return "https://firebasestorage.googleapis.com/v0/b/nomnompassport-16244.firebasestorage.app/o/restaurants%2F$restaurantId.png?alt=media&token=a78b2c70-8a8e-478b-a76e-1110f0439f4f";
  }

  Future<void> removeSavedRestaurant(String restaurantId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentReference savedDocRef = _firestore.collection('saved').doc(user.uid);
        await savedDocRef.update({
          restaurantId: FieldValue.delete(),
        });
        savedRestaurants.removeWhere((restaurant) => restaurant['restaurantId'] == restaurantId);
        print("Successfully removed restaurant: $restaurantId");
      } catch (e) {
        print("Error removing restaurant: $restaurantId - $e");
      }
    }
  }
}

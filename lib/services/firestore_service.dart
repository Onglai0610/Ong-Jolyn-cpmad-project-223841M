import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../model/post.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseStorage storage = FirebaseStorage.instance;
  

  // Save the post data to Firestore
  Future<void> savePostToFirestore({
    required String title,
    required String caption,
    required String restaurantName,
    required double rating,
    required List<File> selectedImages,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    List<String> imageUrls = [];

    try {
      // Upload each image to Firebase Storage
      for (int i = 0; i < selectedImages.length; i++) {
        String imageName = 'posts/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

        // Upload image
        Reference ref = storage.ref().child(imageName);
        UploadTask uploadTask = ref.putFile(selectedImages[i]);
        TaskSnapshot snapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Create the Post object
      Post post = Post(
        uid: user.uid,
        title: title,
        caption: caption,
        restaurantName: restaurantName,
        rating: rating,
        dateTime: DateTime.now(),
        imageUrls: imageUrls, // Storing URLs instead of file names
      );

      // Save the post to Firestore using the Post's toMap method
      await firestore.collection('posts').add(post.toMap());

      // Increment user's stamp count
        await updateUserStamps(user.uid);

    } catch (e) {
      throw Exception('Failed to save post: $e');
    }
  }
  // Update user's stamp count in Firestore
  Future<void> updateUserStamps(String uid) async {
    DocumentReference stampRef = firestore.collection('stamps').doc(uid);

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(stampRef);
      
      if (!snapshot.exists) {
        // If user has no stamps, create with 1 stamp
        transaction.set(stampRef, {'stampCount': 1});
      } else {
        // Increment existing stamp count
        int currentStamps = snapshot['stampCount'] as int;
        transaction.update(stampRef, {'stampCount': currentStamps + 1});
      }
    });
  }

  /// Save restaurant to Firestore under 'saved' collection
  Future<void> saveToNomNomJourney({
    required BuildContext context,
    required String restaurantId,
    required String restaurantName,
    required String cuisine,
    required String description,
    required double rating,
    required String rewards,
    required String imageUrl,
    required List<String> outletAddresses,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to save restaurants!")),
      );
      return;
    }

    try {
      await firestore.collection('saved').doc(user.uid).set({
        restaurantId: {
          'restaurantName': restaurantName,
          'cuisine': cuisine,
          'description': description,
          'rating': rating,
          'rewards': rewards,
          'imageUrl': imageUrl,
          'outletAddresses': outletAddresses,
          'savedAt': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Restaurant saved to your NOM NOM Journey!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error saving restaurant: $e")),
      );
    }
  }

  /// Fetch restaurant outlet locations as a list of maps
  Future<List<Map<String, dynamic>>> getOutletData(String restaurantId) async {
  List<Map<String, dynamic>> outlets = [];
  try {
    // Fetch outlets for the given restaurantId
    QuerySnapshot outletSnapshot = await FirebaseFirestore.instance
        .collection('outlets')
        .where('restaurant', isEqualTo: restaurantId)
        .get();

    // Fetch the restaurant name from the restaurant document
    DocumentSnapshot restaurantSnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantId)
        .get();

    String restaurantName = '';
    if (restaurantSnapshot.exists) {
      restaurantName = restaurantSnapshot['restaurantName'] ?? 'Unknown Restaurant';
    }

    // Process outlet data and add it to the list
    for (var doc in outletSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('lat') && data.containsKey('lon')) {
        try {
          double latitude = double.tryParse(data['lat'].toString()) ?? 0.0;
          double longitude = double.tryParse(data['lon'].toString()) ?? 0.0;

          if (latitude != 0.0 && longitude != 0.0) {
            outlets.add({
              'id': doc.id,
              'address': data['address'] ?? 'Unnamed Outlet',
              'lat': latitude,
              'lon': longitude,
              'restaurantName': restaurantName, // Add restaurantName to the outlet data
            });
          }
        } catch (e) {
          print("Error parsing lat/lon: $e");
        }
      }
    }
  } catch (e) {
    print("Error fetching outlet data: $e");
  }
  print("Fetched Outlets: $outlets"); // Debugging
  return outlets;
}





}
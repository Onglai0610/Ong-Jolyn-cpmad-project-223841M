import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FirebaseAuthService {
  // FirebaseAuth & Firestore Instances
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var stampCount = 0.obs;

  // Sign In User
  Future<User?> signIn({String? email, String? password}) async {
    try {
      UserCredential ucred = await _fbAuth.signInWithEmailAndPassword(
        email: email!, password: password!);
      User? user = ucred.user;
      debugPrint("Signed In successful! userid: ${user?.uid}, user: $user.");
      return user!;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.TOP);
      return null;
    } catch (e) {
      return null;
    }
  }

  // Sign Up User
  Future<User?> signUp({String? email, String? password, String? username}) async {
    try {
      UserCredential ucred = await _fbAuth.createUserWithEmailAndPassword(
        email: email!, password: password!);
      User? user = ucred.user;
      debugPrint('Signed Up successful! user: $user');

      // Save user to Firestore upon signup
      await _firestore.collection('users').doc(user!.uid).set({
        'email': email,
        'username': username,
      });

      // Create a stamps collection and set initial stampCount to 0
      await _firestore.collection('stamps').doc(user.uid).set({
        'stampCount': 0,
      });

      debugPrint('Stamps collection created successfully for user: ${user.uid}');

      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.TOP);
      return null;
    } catch (e) {
      return null;
    }
  }

  // Sign Out User
  Future<void> signOut() async {
    await _fbAuth.signOut();
  }

  // Get Current User
  User? getCurrentUser() {
    return _fbAuth.currentUser;
  }

  // Get current user's data from Firestore
  Future<Map<String, String>> getUserData() async {
    User? user = _fbAuth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        return {
          "username": userDoc["username"] ?? "",
          "email": userDoc["email"] ?? "",
        };
      }
    }
    return {"username": "", "email": ""};
  }

  // Update user's profile (only username in Firestore)
  Future<void> updateUserProfile(String newUsername) async {
    User? user = _fbAuth.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        "username": newUsername,
      });
    }
  }

  Future<void> fetchStampCount() async {
    User? user = _fbAuth.currentUser;

    if (user != null) {
      DocumentSnapshot stampDoc = await _firestore.collection('stamps').doc(user.uid).get();

      if (stampDoc.exists) {
        stampCount.value = stampDoc['stampCount'] ?? 0; // Get stamp count, default to 0
      }
    }
  }
}

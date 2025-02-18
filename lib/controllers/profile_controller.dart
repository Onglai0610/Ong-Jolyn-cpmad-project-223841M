import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/firebaseauth_services.dart';

class ProfileController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  var username = "".obs;
  var email = "".obs;
  var isLoading = true.obs; // loading state

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  // Load user data from FirebaseAuthService
  Future<void> _loadUserData() async {
    isLoading.value = true; // Start loading
    Map<String, String> userData = await _authService.getUserData();
    username.value = userData["username"] ?? "";
    email.value = userData["email"] ?? "";
    isLoading.value = false; // Done loading
  }

  // Update profile
  Future<void> updateProfile(String newUsername) async {
    await _authService.updateUserProfile(newUsername);
    Fluttertoast.showToast(msg: "Profile updated successfully!");
    username.value = newUsername;
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    Fluttertoast.showToast(msg: "Signed out successfully!");
    Get.offNamed('/login');
  }
}

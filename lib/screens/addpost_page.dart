import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firestore_service.dart';

class PostController extends GetxController {
  // TextEditingControllers for user inputs
  var titleController = TextEditingController();
  var captionController = TextEditingController();
  var restaurantNameController = TextEditingController();
  var ratingController = TextEditingController();

  // Reactive list for selected images
  var selectedImages = <File>[].obs;

  final FirestoreService firestoreService = FirestoreService();

  // Method to pick multiple images
  Future<void> pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages.isNotEmpty) {
      selectedImages.addAll(pickedImages.map((image) => File(image.path)));
    }
  }

  // Save post to Firestore
  Future<void> savePost() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar('Error', 'You need to be logged in to add a post');
      return;
    }

    final String title = titleController.text.trim();
    final String caption = captionController.text.trim();
    final String restaurantName = restaurantNameController.text.trim();
    final double? rating = double.tryParse(ratingController.text.trim());

    if (title.isEmpty || caption.isEmpty || restaurantName.isEmpty || rating == null || rating < 0 || rating > 5) {
      Get.snackbar('Error', 'Please fill out all fields with valid information');
      return;
    }
    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image');
      return;
    }

    try {
      // Save the post to Firestore
      await firestoreService.savePostToFirestore(
        title: title,
        caption: caption,
        restaurantName: restaurantName,
        rating: rating,
        selectedImages: selectedImages,
      );

      // Clear inputs and images after successful save
      titleController.clear();
      captionController.clear();
      restaurantNameController.clear();
      ratingController.clear();
      selectedImages.clear();

      Get.snackbar('Success', 'Post added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add post: $e');
    }
  }
}

class AddPostPage extends StatelessWidget {
  // GetX Controller
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, 
        title: Text(
          'New Post',
          style: TextStyle(color: Colors.black), 
        ),
        elevation: 0, // Remove shadow
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          if (Navigator.canPop(context)) 
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: Icon(Icons.save, color: Colors.black),
                onPressed: postController.savePost,
              ),
            ),
        ],
      ),
      body: Obx(() {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFE3BF), // Top gradient color
                Color(0xFFFFFFFF), // Bottom gradient color
              ],
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image upload section as horizontal ListView
                Container(
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postController.selectedImages.length + 1, // +1 for the add image button
                    itemBuilder: (context, index) {
                      if (index == postController.selectedImages.length) {
                        return GestureDetector(
                          onTap: postController.pickImages,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 150, 
                                height: 150, 
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 50, // Increased icon size
                                      color: Colors.orange,
                                    ),
                                    Text(
                                      "Add image",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // selected image
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                postController.selectedImages[index],
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                postController.selectedImages.removeAt(index);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                radius: 15,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Title and Caption Fields
                buildTextField(postController.titleController, 'Post Title'),
                SizedBox(height: 10,),
                buildTextField(postController.captionController, 'Caption', maxLines: 3),
                SizedBox(height: 10,),
                buildTextField(postController.restaurantNameController, 'Restaurant Name'),
                SizedBox(height: 10,),
                buildTextField(postController.ratingController, 'Rating (0-5)', keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: postController.savePost,
                  child: const Text('Post'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {int? maxLines, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10), 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), 
            spreadRadius: 2, 
            blurRadius: 5, 
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none, 
          contentPadding: EdgeInsets.all(12), 
        ),
      ),
    );
  }
}

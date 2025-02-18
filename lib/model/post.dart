class Post {
  String? uid;
  String? title;
  String? caption;
  String? restaurantName;
  double? rating;
  DateTime? dateTime;
  List<String>? imageUrls;

  Post({
    this.uid,
    this.title,
    this.caption,
    this.restaurantName,
    this.rating,
    this.dateTime,
    this.imageUrls,
  });

  // Constructor to create a Post from Firestore data (Map)
  Post.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    title = data['title'];
    caption = data['caption'];
    restaurantName = data['restaurantName'];
    rating = data['rating'] != null ? (data['rating'] as num).toDouble() : null;
    dateTime = data['dateTime'] != null ? DateTime.parse(data['dateTime']) : null;
    imageUrls = data['imageUrls'] != null ? List<String>.from(data['imageUrls']) : [];
  }

  // Method to convert a Post object into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'caption': caption,
      'restaurantName': restaurantName,
      'rating': rating,
      'dateTime': dateTime?.toIso8601String(),
      'imageUrls': imageUrls,
    };
  }
}

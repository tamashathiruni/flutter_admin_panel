import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String clientId;
  final int? rating; // Nullable in case the rating is not found

  Rating({required this.clientId, this.rating});

  factory Rating.fromDocument(String clientId, DocumentSnapshot doc) {
    // Construct the dynamic field name
    String ratingFieldName = clientId + 'rating';

    // Convert the document data to a Map
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Check if the field exists
    int? rating =
        data.containsKey(ratingFieldName) ? data[ratingFieldName] as int : null;

    return Rating(
      clientId: clientId,
      rating: rating, // If the field is missing, rating will be null
    );
  }
}

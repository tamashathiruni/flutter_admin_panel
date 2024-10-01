import 'package:admin/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

       final CollectionReference userCollectionn =
      FirebaseFirestore.instance.collection('payment');

  Future<List<UserModel>> fetchUsers() async {
    QuerySnapshot querySnapshot = await userCollection.get();
    List<UserModel> users = querySnapshot.docs.map((doc) {
      return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
    print('Fetched users: $users'); // Debug line
    return users;
  }

  Future<void> updatePaymentStatus(String userId, bool payment) async {
    await userCollection.doc(userId).update({
      'payment': payment, // Update the field in Firestore
    });
  }

    Future<void> updatePaymentStatuss(String userId, bool payment) async {
    await userCollectionn.doc(userId).update({
      'payment': payment, // Update the field in Firestore
    });
  }
}

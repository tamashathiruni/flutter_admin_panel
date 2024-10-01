import 'package:admin/models/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class progresscontraller {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('progress');

  Future<List<userprogress>> getuserprogress() async {
    QuerySnapshot querySnapshot = await userCollection.get();
    List<userprogress> progress = querySnapshot.docs.map((doc) {
      return userprogress.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
    print('Fetched users: $progress'); // Debug line
    return progress;
  }
}

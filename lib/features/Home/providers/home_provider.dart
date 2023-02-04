import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartchat/interceptors/di.dart';
import 'package:smartchat/resources/all_resources.dart';

class HomeProvider {
  // final FirebaseFirestore firebaseFirestore;

  HomeProvider();
  final firebaseFirestore = sl<FirebaseFirestore>();
  Future<void> updateFirestoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(updateData);
  }

  Stream<QuerySnapshot> getFirestoreData(
      String collectionPath, int limit, String? textSearch) {
    print("$textSearch");
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .where(FirestoreConstants.displayName, isGreaterThan: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .snapshots();
    }
  }
}

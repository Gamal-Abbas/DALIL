import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collection,
  }) async {
    return await _firestore.collection(collection).get();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getDoc({
    required String id,
    required final String collection,
  }) async {
    return await _firestore.collection(collection).doc(id).get();
  }

  static Future<QuerySnapshot<Object?>> getCollectionData({
    required String collection,
  }) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(collection)
        .get();
    return snapshot;
  }

  static Map<String, dynamic> getDocData({
    required DocumentSnapshot<Object?> doc,
  }) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return data;
  }
}

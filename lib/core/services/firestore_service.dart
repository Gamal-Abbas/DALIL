import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<PlaceModel>> getPlaces(String collection) {
    return _db.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PlaceModel.fromFirestore(doc))
          .toList();
    });
  }

  // 🔥 الجديد (للسيرش)
  Future<List<PlaceModel>> getAllPlaces() async {
    final collections = ["attractions", "kings", "eras"];

    List<PlaceModel> all = [];

    for (var col in collections) {
      final snapshot = await _db.collection(col).get();

      all.addAll(
        snapshot.docs.map((doc) => PlaceModel.fromFirestore(doc)),
      );
    }

    return all;
  }
}
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
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/place_model.dart';

abstract class PlaceRemoteDataSource {
  Future<List<PlaceModel>> getPlacesByCity(String cityId);
}

class PlaceRemoteDataSourceImpl implements PlaceRemoteDataSource {
  final FirebaseFirestore firestore;

  PlaceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PlaceModel>> getPlacesByCity(String cityId) async {
    debugPrint("Requested city: $cityId");
    try {
      final querySnapshot = await firestore
          .collection('places')
          .where('cityId', isEqualTo: cityId)
          .get();

      debugPrint("Documents found: ${querySnapshot.docs.length}");
      for (final doc in querySnapshot.docs) {
        debugPrint("Doc id: ${doc.id}");
      }

      return querySnapshot.docs
          .map((doc) => PlaceModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get places by city: $e');
    }
  }
}

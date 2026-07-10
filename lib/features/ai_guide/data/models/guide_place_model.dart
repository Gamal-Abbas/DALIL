import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/guide_place_entity.dart';

class GuidePlaceModel extends GuidePlaceEntity {
  const GuidePlaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.location,
  });

  factory GuidePlaceModel.fromFirestore(DocumentSnapshot doc) {
    try {
      debugPrint("Parsing document: ${doc.id}");
      debugPrint(doc.data().toString());
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final model = GuidePlaceModel.fromMap(data, doc.id);
      debugPrint("Parsed ${model.name} (${model.location.latitude}, ${model.location.longitude})");
      return model;
    } catch (e) {
      debugPrint("Parsing Error: $e");
      rethrow;
    }
  }

  factory GuidePlaceModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return GuidePlaceModel(
      id: docId ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      location: map['location'] as GeoPoint? ?? const GeoPoint(0, 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
    };
  }
}

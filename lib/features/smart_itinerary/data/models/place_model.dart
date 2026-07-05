import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.cityId,
    required super.categories,
    required super.visitDuration,
    required super.ticketPrice,
    required super.rating,
    required super.location,
    required super.openingTime,
    required super.closingTime,
    required super.priority,
    required super.imageUrl,
    required super.description,
  });

  factory PlaceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PlaceModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  factory PlaceModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return PlaceModel(
      id: docId ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      cityId: map['cityId'] as String? ?? '',
      categories: List<String>.from(map['categories'] ?? []),
      visitDuration: (map['visitDuration'] as num?)?.toInt() ?? 0,
      ticketPrice: (map['ticketPrice'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      location: map['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      openingTime: map['openingTime'] as String? ?? '',
      closingTime: map['closingTime'] as String? ?? '',
      priority: (map['priority'] as num?)?.toInt() ?? 0,
      imageUrl: map['imageUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cityId': cityId,
      'categories': categories,
      'visitDuration': visitDuration,
      'ticketPrice': ticketPrice,
      'rating': rating,
      'location': location,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'priority': priority,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}

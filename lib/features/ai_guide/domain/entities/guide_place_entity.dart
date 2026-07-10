import 'package:cloud_firestore/cloud_firestore.dart';

class GuidePlaceEntity {
  final String id;
  final String name;
  final String description;
  final GeoPoint location;

  const GuidePlaceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
  });
}

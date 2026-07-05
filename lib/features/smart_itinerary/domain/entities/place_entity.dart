import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceEntity {
  final String id;
  final String name;
  final String cityId;
  final List<String> categories;
  final int visitDuration;
  final int ticketPrice;
  final double rating;
  final GeoPoint location;
  final String openingTime;
  final String closingTime;
  final int priority;
  final String imageUrl;
  final String description;

  const PlaceEntity({
    required this.id,
    required this.name,
    required this.cityId,
    required this.categories,
    required this.visitDuration,
    required this.ticketPrice,
    required this.rating,
    required this.location,
    required this.openingTime,
    required this.closingTime,
    required this.priority,
    required this.imageUrl,
    required this.description,
  });
}

import 'place_entity.dart';

class ItineraryEntity {
  final List<PlaceEntity> places;
  final int totalCost;
  final int totalDuration;
  final double averageRating;

  const ItineraryEntity({
    required this.places,
    required this.totalCost,
    required this.totalDuration,
    required this.averageRating,
  });
}

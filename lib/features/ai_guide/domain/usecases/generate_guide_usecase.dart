import 'dart:math' as math;
import '../entities/guide_place_entity.dart';
import '../entities/guide_response.dart';
import '../repositories/guide_repository.dart';

class GenerateGuideParams {
  final double currentLatitude;
  final double currentLongitude;
  final Function(GuidePlaceEntity)? onPlaceDetected;

  const GenerateGuideParams({
    required this.currentLatitude,
    required this.currentLongitude,
    this.onPlaceDetected,
  });
}

class GenerateGuideUseCase {
  final GuideRepository repository;
  GuidePlaceEntity? _lastExplainedPlace;

  GenerateGuideUseCase(this.repository);

  void resetLastExplainedPlace() {
    _lastExplainedPlace = null;
  }

  Future<GuideResponse?> call(GenerateGuideParams params) async {
    final places = await repository.getAllPlaces();

    if (places.isEmpty) {
      return null;
    }

    // If the user has moved more than 100 meters away from the last explained place, reset it.
    if (_lastExplainedPlace != null) {
      final distanceToLast = _calculateHaversineDistanceMeters(
        params.currentLatitude,
        params.currentLongitude,
        _lastExplainedPlace!.location.latitude,
        _lastExplainedPlace!.location.longitude,
      );
      if (distanceToLast > 100.0) {
        _lastExplainedPlace = null;
      }
    }

    final nearestPlace = _findNearestPlace(
      params.currentLatitude,
      params.currentLongitude,
      places,
    );

    // If the nearest place is farther than 50 meters (or not found), return null.
    if (nearestPlace == null) {
      return null;
    }

    // Prevent repeating the guide for the same place while still inside its zone
    if (_lastExplainedPlace?.id == nearestPlace.id) {
      return null;
    }

    _lastExplainedPlace = nearestPlace;

    // Trigger the callback so the UI knows we are now generating a guide for this place
    params.onPlaceDetected?.call(nearestPlace);

    // 7. Generate a Gemini Prompt
    final prompt = '''
You are a professional Egyptian tour guide.

The visitor is standing in front of:

Name:
${nearestPlace.name}

Description:
${nearestPlace.description}

Requirements:

- Maximum 120 words.
- Friendly.
- Natural spoken English.
- Exciting.
- Speak directly to the tourist.
- Do NOT invent historical facts.
- End with one interesting fact.
''';

    final generatedGuide = await repository.generateGuide(prompt.trim());

    // 9. Return GuideResponse
    return GuideResponse(
      place: nearestPlace,
      generatedGuide: generatedGuide,
    );
  }

  GuidePlaceEntity? _findNearestPlace(
    double lat,
    double lon,
    List<GuidePlaceEntity> places,
  ) {
    GuidePlaceEntity? nearest;
    double minDistance = double.maxFinite;

    for (final place in places) {
      final distance = _calculateHaversineDistanceMeters(
        lat,
        lon,
        place.location.latitude,
        place.location.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearest = place;
      }
    }

    if (minDistance > 50.0) {
      return null;
    }

    return nearest;
  }

  /// Calculates the distance between two geographical points using the Haversine formula.
  /// Returns the distance in meters.
  double _calculateHaversineDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double r = 6371000.0; // Earth radius in meters
    const double p = math.pi / 180.0;
    
    final double a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2.0 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1.0 - math.cos((lon2 - lon1) * p)) /
            2.0;

    return 2.0 * r * math.asin(math.sqrt(a));
  }
}

import 'package:flutter/foundation.dart';
import '../entities/itinerary_entity.dart';
import '../entities/place_entity.dart';
import '../repositories/place_repository.dart';

class GenerateItineraryParams {
  final String cityId;
  final int availableMinutes;
  final int budget;
  final List<String> interests;

  const GenerateItineraryParams({
    required this.cityId,
    required this.availableMinutes,
    required this.budget,
    required this.interests,
  });
}

class GenerateItineraryUseCase {
  final PlaceRepository repository;

  GenerateItineraryUseCase(this.repository);

  Future<ItineraryEntity> call(GenerateItineraryParams params) async {
    // 1. Fetch places for the given city
    final allPlaces = await repository.getPlacesByCity(params.cityId);
    debugPrint("GenerateItineraryUseCase: allPlaces.length = ${allPlaces.length}");

    // 2. Score places based on the algorithm
    final scoredPlaces = _scorePlaces(allPlaces, params.interests);

    // 3. Sort descending by score
    scoredPlaces.sort((a, b) => b.score.compareTo(a.score));

    // 4. Build the itinerary
    int remainingTime = params.availableMinutes;
    int remainingBudget = params.budget;
    List<PlaceEntity> selectedPlaces = [];

    for (final scoredPlace in scoredPlaces) {
      final place = scoredPlace.place;

      // Check if place fits within remaining time and budget constraints
      if (place.ticketPrice <= remainingBudget &&
          place.visitDuration <= remainingTime) {
        
        selectedPlaces.add(place);
        remainingBudget -= place.ticketPrice;
        remainingTime -= place.visitDuration;
      }
    }

    // 5. Calculate totals and averages for the final entity
    final totalCost = params.budget - remainingBudget;
    final totalDuration = params.availableMinutes - remainingTime;
    
    double averageRating = 0.0;
    if (selectedPlaces.isNotEmpty) {
      final totalRating = selectedPlaces.fold<double>(
          0.0, (sum, place) => sum + place.rating);
      averageRating = totalRating / selectedPlaces.length;
    }
    
    debugPrint("GenerateItineraryUseCase: selected places count = ${selectedPlaces.length}");

    return ItineraryEntity(
      places: selectedPlaces,
      totalCost: totalCost,
      totalDuration: totalDuration,
      averageRating: averageRating,
    );
  }

  /// Private helper method to calculate the score for each place
  List<_ScoredPlace> _scorePlaces(
    List<PlaceEntity> places,
    List<String> userInterests,
  ) {
    return places.map((place) {
      double score = 0.0;

      // Rule 1: Interest Matching
      // For every category that exists inside the user's interests: +30 points
      for (final category in place.categories) {
        if (userInterests.contains(category)) {
          score += 30.0;
        }
      }

      // Rule 2: Priority
      // score += priority * 5
      score += place.priority * 5.0;

      // Rule 3: Rating
      // score += rating * 10
      score += place.rating * 10.0;

      // Rule 4: Cost Penalty
      // score -= ticketPrice / 100
      score -= place.ticketPrice / 100.0;

      // Rule 5: Time Penalty
      // score -= visitDuration / 30
      score -= place.visitDuration / 30.0;

      return _ScoredPlace(place: place, score: score);
    }).toList();
  }
}

/// A private helper class to associate a PlaceEntity with its calculated score
class _ScoredPlace {
  final PlaceEntity place;
  final double score;

  _ScoredPlace({
    required this.place,
    required this.score,
  });
}

import 'package:flutter/foundation.dart';
import 'dart:math' as math;
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

    if (allPlaces.isEmpty) {
      return const ItineraryEntity(places: [], totalCost: 0, totalDuration: 0, averageRating: 0.0);
    }

    // 2. Base Scoring (Value)
    final scoredPlaces = _scorePlaces(allPlaces, params.interests);

    // 3. Dynamic Selection & Geographic Routing Algorithm (Knapsack + Nearest Neighbor)
    int remainingTime = params.availableMinutes;
    int remainingBudget = params.budget;
    List<PlaceEntity> selectedPlaces = [];
    
    List<_ScoredPlace> unvisited = List.from(scoredPlaces);
    PlaceEntity? currentPlace;

    while (unvisited.isNotEmpty && remainingTime > 0 && remainingBudget > 0) {
      _ScoredPlace? bestNextPlace;
      double bestDynamicScore = -double.maxFinite;
      int bestNextTransitTime = 0;

      for (final candidate in unvisited) {
        final place = candidate.place;
        int transitTime = 0;
        double distanceKm = 0.0;

        // Calculate transit time from the current location (if not the first place)
        if (currentPlace != null) {
          distanceKm = _calculateDistance(
            currentPlace.location.latitude,
            currentPlace.location.longitude,
            place.location.latitude,
            place.location.longitude,
          );
          // Assuming ~3 mins per km in city traffic + 10 mins buffer for parking/walking
          transitTime = (distanceKm * 3.0).toInt() + 10;
        }

        // Check if the place fits within remaining time and budget constraints
        if (place.ticketPrice <= remainingBudget && (place.visitDuration + transitTime) <= remainingTime) {
          
          // Knapsack Density Score: (Value / Cost)
          // We combine time cost and monetary cost into a single 'cost factor'.
          // Let's assume 1 EGP is conceptually equivalent to 0.5 minutes for weighting purposes.
          double costFactor = (place.visitDuration + transitTime) + (place.ticketPrice * 0.5);
          
          double densityScore = (candidate.score * 100.0) / (costFactor > 0 ? costFactor : 1.0);
          
          // Geographic Penalty: Strongly penalize far away places to create a logical route
          if (currentPlace != null) {
            densityScore -= (distanceKm * 5.0); 
          }

          if (densityScore > bestDynamicScore) {
            bestDynamicScore = densityScore;
            bestNextPlace = candidate;
            bestNextTransitTime = transitTime;
          }
        }
      }

      // If we found a suitable next place
      if (bestNextPlace != null) {
        final place = bestNextPlace.place;
        selectedPlaces.add(place);
        
        remainingBudget -= place.ticketPrice;
        remainingTime -= (place.visitDuration + bestNextTransitTime);
        
        currentPlace = place;
        unvisited.remove(bestNextPlace);
      } else {
        // No more places fit the budget/time
        break;
      }
    }

    // 4. Calculate totals and averages for the final entity
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

  /// Calculates Base Value/Score for each place
  List<_ScoredPlace> _scorePlaces(
    List<PlaceEntity> places,
    List<String> userInterests,
  ) {
    return places.map((place) {
      double score = 10.0; // Base minimal score

      // Rule 1: Interest Matching (Very High Weight)
      for (final category in place.categories) {
        if (userInterests.contains(category)) {
          score += 50.0;
        }
      }

      // Rule 2: Priority (High Weight)
      score += place.priority * 10.0;

      // Rule 3: Rating (Medium Weight)
      score += place.rating * 15.0;

      // Note: Time and Cost penalties are removed from here because they are 
      // dynamically handled in the density calculation during the selection phase.
      
      return _ScoredPlace(place: place, score: score);
    }).toList();
  }

  /// Haversine formula to calculate distance in Kilometers between two GeoPoints
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2.0 +
        math.cos(lat1 * p) * math.cos(lat2 * p) * (1.0 - math.cos((lon2 - lon1) * p)) / 2.0;
    return 12742.0 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km
  }
}

/// A private helper class to associate a PlaceEntity with its base score
class _ScoredPlace {
  final PlaceEntity place;
  final double score;

  _ScoredPlace({
    required this.place,
    required this.score,
  });
}

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
  final double? userLat;
  final double? userLon;

  const GenerateItineraryParams({
    required this.cityId,
    required this.availableMinutes,
    required this.budget,
    required this.interests,
    this.userLat,
    this.userLon,
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
    final scoredPlaces = _scorePlaces(allPlaces, params);

    // 3. Dynamic Selection & Geographic Routing Algorithm (Knapsack + Nearest Neighbor)
    int remainingTime = params.availableMinutes;
    int remainingBudget = params.budget;
    List<PlaceEntity> selectedPlaces = [];
    
    List<_ScoredPlace> unvisited = List.from(scoredPlaces);
    PlaceEntity? currentPlace;
    
    // Conceptually proxy the user's location as the starting point if available
    bool hasUserLocation = params.userLat != null && params.userLon != null;
    double currentLat = params.userLat ?? 0.0;
    double currentLon = params.userLon ?? 0.0;
    
    // Safety Check: If the user is > 100km away from the highest scored place in the city,
    // they are likely planning remotely. Ignore their current location to avoid massive transit times.
    if (hasUserLocation && unvisited.isNotEmpty) {
      final anchorPlace = unvisited.first.place;
      final distanceToCity = _calculateDistance(
        currentLat, currentLon, 
        anchorPlace.location.latitude, anchorPlace.location.longitude
      );
      if (distanceToCity > 100.0) {
        hasUserLocation = false;
        debugPrint("User is $distanceToCity km away. Ignoring local start point.");
      }
    }

    while (unvisited.isNotEmpty && remainingTime > 0 && remainingBudget > 0) {
      _ScoredPlace? bestNextPlace;
      double bestDynamicScore = -double.maxFinite;
      int bestNextTransitTime = 0;

      for (final candidate in unvisited) {
        final place = candidate.place;
        int transitTime = 0;
        double distanceKm = 0.0;

        // Calculate transit time from the current location (or user location for the very first stop)
        if (currentPlace != null || hasUserLocation) {
          double startLat = currentPlace?.location.latitude ?? currentLat;
          double startLon = currentPlace?.location.longitude ?? currentLon;
          
          distanceKm = _calculateDistance(
            startLat,
            startLon,
            place.location.latitude,
            place.location.longitude,
          );
          // Assuming ~3 mins per km in city traffic + 10 mins buffer for parking/walking
          transitTime = (distanceKm * 3.0).toInt() + 10;
        }

        // Check if the place fits within remaining time and budget constraints
        if (place.ticketPrice <= remainingBudget && (place.visitDuration + transitTime) <= remainingTime) {
          
          // To balance the Knapsack properly for TIME, we use a Time Density approach.
          // This prevents a single 3-hour place from hogging all the time if two 1-hour places 
          // give a better combined experience. We divide the base score by the time it consumes.
          // We DO NOT penalize for ticket price, as long as it fits the budget limit.
          double totalTimeForPlace = (place.visitDuration + transitTime).toDouble();
          
          // Multiply by 100 to keep numbers readable
          double timeDensityScore = (candidate.score * 100.0) / (totalTimeForPlace > 0 ? totalTimeForPlace : 1.0);
          
          double dynamicScore = timeDensityScore;
          
          if (currentPlace != null || hasUserLocation) {
            dynamicScore -= (distanceKm * 2.0); // Geographic penalty to keep places clustered
          }

          if (dynamicScore > bestDynamicScore) {
            bestDynamicScore = dynamicScore;
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
    GenerateItineraryParams params,
  ) {
    return places.map((place) {
      double score = 10.0; // Base minimal score

      // Rule 1: Interest Matching (Very High Weight)
      for (final category in place.categories) {
        if (params.interests.contains(category)) {
          score += 50.0;
        }
      }

      // Rule 2: Priority (High Weight)
      score += place.priority * 10.0;

      // Rule 3: Rating (Medium Weight)
      score += place.rating * 15.0;

      // Rule 4: Budget Persona Match (The 'Luxury' Rule)
      // If the user has a high budget, they are looking for premium experiences.
      if (params.budget >= 1000) {
        // Boost expensive places. A 400 EGP ticket gives +40 points.
        score += (place.ticketPrice / 10.0); 
      } else if (params.budget <= 500) {
        // If budget is tight, lightly penalize expensive places to leave room for more activities.
        score -= (place.ticketPrice / 20.0);
      }

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

import 'package:flutter/material.dart';

void main() {
  List<PlaceEntity> allPlaces = [
    PlaceEntity(
      id: "1", name: "Pyramids", cityId: "giza", categories: ["History"],
      visitDuration: 180, ticketPrice: 500, rating: 4.8, location: "loc", openingTime: "9", closingTime: "17", priority: 10, imageUrl: "", description: ""
    )
  ];
  
  List<String> interests = ["History"];
  int budget = 1000;
  int availableMinutes = 360;

  var scoredPlaces = allPlaces.map((place) {
    double score = 0.0;
    for (final category in place.categories) {
      if (interests.contains(category)) {
        score += 30.0;
      }
    }
    score += place.priority * 5.0;
    score += place.rating * 10.0;
    score -= place.ticketPrice / 100.0;
    score -= place.visitDuration / 30.0;
    return _ScoredPlace(place: place, score: score);
  }).toList();

  scoredPlaces.sort((a, b) => b.score.compareTo(a.score));

  int remainingTime = availableMinutes;
  int remainingBudget = budget;
  List<PlaceEntity> selectedPlaces = [];

  for (final scoredPlace in scoredPlaces) {
    final place = scoredPlace.place;
    if (place.ticketPrice <= remainingBudget &&
        place.visitDuration <= remainingTime) {
      selectedPlaces.add(place);
      remainingBudget -= place.ticketPrice;
      remainingTime -= place.visitDuration;
    }
  }
  print("Selected places count: \${selectedPlaces.length}");
}

class PlaceEntity {
  final String id, name, cityId, openingTime, closingTime, imageUrl, description;
  final List<String> categories;
  final int visitDuration, ticketPrice, priority;
  final double rating;
  final dynamic location;
  
  PlaceEntity({required this.id, required this.name, required this.cityId, required this.categories, required this.visitDuration, required this.ticketPrice, required this.rating, required this.location, required this.openingTime, required this.closingTime, required this.priority, required this.imageUrl, required this.description});
}

class _ScoredPlace {
  final PlaceEntity place;
  final double score;
  _ScoredPlace({required this.place, required this.score});
}

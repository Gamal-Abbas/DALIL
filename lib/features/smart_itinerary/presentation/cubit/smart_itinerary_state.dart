import '../../domain/entities/itinerary_entity.dart';

abstract class SmartItineraryState {}

class SmartItineraryInitial extends SmartItineraryState {}

class SmartItineraryLoading extends SmartItineraryState {}

class SmartItineraryLoaded extends SmartItineraryState {
  final ItineraryEntity itinerary;
  SmartItineraryLoaded({required this.itinerary});
}

class SmartItineraryError extends SmartItineraryState {
  final String message;
  SmartItineraryError({required this.message});
}

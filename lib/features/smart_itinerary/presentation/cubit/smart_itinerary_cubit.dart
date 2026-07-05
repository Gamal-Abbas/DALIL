import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../domain/usecases/generate_itinerary_usecase.dart';
import 'smart_itinerary_state.dart';

class SmartItineraryCubit extends Cubit<SmartItineraryState> {
  final GenerateItineraryUseCase generateItineraryUseCase;

  SmartItineraryCubit({required this.generateItineraryUseCase}) 
      : super(SmartItineraryInitial());

  Future<void> generateItinerary({
    required String cityId,
    required int availableMinutes,
    required int budget,
    required List<String> interests,
  }) async {
    debugPrint("Cubit emitting SmartItineraryLoading");
    emit(SmartItineraryLoading());

    try {
      final params = GenerateItineraryParams(
        cityId: cityId,
        availableMinutes: availableMinutes,
        budget: budget,
        interests: interests,
      );

      final itinerary = await generateItineraryUseCase(params);
      debugPrint("Cubit emitting SmartItineraryLoaded");
      emit(SmartItineraryLoaded(itinerary: itinerary));
    } catch (e) {
      debugPrint("Cubit emitting SmartItineraryError: $e");
      emit(SmartItineraryError(message: e.toString()));
    }
  }
}

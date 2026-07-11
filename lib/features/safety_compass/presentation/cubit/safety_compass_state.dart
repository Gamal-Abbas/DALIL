import 'package:dalil/features/safety_compass/domain/entities/location_data.dart';
import 'package:dalil/features/safety_compass/domain/entities/compass_data.dart';

sealed class SafetyCompassState {
  const SafetyCompassState();
}

final class Initial extends SafetyCompassState {
  const Initial();
}

final class Loading extends SafetyCompassState {
  const Loading();
}

final class LocationLoaded extends SafetyCompassState {
  final LocationData locationData;

  const LocationLoaded({required this.locationData});
}

final class CompassUpdated extends SafetyCompassState {
  final CompassData compassData;
  final LocationData? locationData;

  const CompassUpdated({
    required this.compassData,
    this.locationData,
  });
}

final class SafetyCompassError extends SafetyCompassState {
  final String message;

  const SafetyCompassError({required this.message});
}

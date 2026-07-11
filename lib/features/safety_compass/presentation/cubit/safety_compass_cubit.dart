import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/safety_compass/domain/entities/compass_data.dart';
import 'package:dalil/features/safety_compass/domain/entities/location_data.dart';
import 'package:dalil/features/safety_compass/domain/repositories/location_repository.dart';
import 'package:dalil/features/safety_compass/domain/usecases/get_current_location_usecase.dart';
import 'package:dalil/features/safety_compass/domain/usecases/get_compass_heading_usecase.dart';
import 'package:dalil/features/safety_compass/presentation/cubit/safety_compass_state.dart';

class SafetyCompassCubit extends Cubit<SafetyCompassState> {
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final GetCompassHeadingUseCase _getCompassHeadingUseCase;
  final LocationRepository _locationRepository;

  StreamSubscription<CompassData>? _compassSubscription;
  LocationData? _currentLocation;

  SafetyCompassCubit({
    required GetCurrentLocationUseCase getCurrentLocationUseCase,
    required GetCompassHeadingUseCase getCompassHeadingUseCase,
    required LocationRepository locationRepository,
  })  : _getCurrentLocationUseCase = getCurrentLocationUseCase,
        _getCompassHeadingUseCase = getCompassHeadingUseCase,
        _locationRepository = locationRepository,
        super(const Initial());

  Future<void> initialize() async {
    emit(const Loading());

    final permissionResult = await _locationRepository.checkAndRequestPermission();
    if (permissionResult case Failure(:final message)) {
      emit(SafetyCompassError(message: message));
      return;
    }
    if (permissionResult case Success(data: final hasPermission)) {
      if (!hasPermission) {
        emit(const SafetyCompassError(
          message: 'Location permission denied. Please enable it from settings.',
        ));
        return;
      }
    }

    final gpsResult = await _locationRepository.isGpsEnabled();
    if (gpsResult case Success(data: final isEnabled)) {
      if (!isEnabled) {
        emit(const SafetyCompassError(
          message: 'GPS is disabled. Please enable location services.',
        ));
        return;
      }
    }

    await _fetchLocation();
    _startCompassStream();
  }

  Future<void> refreshLocation() async {
    await _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    final result = await _getCurrentLocationUseCase();
    if (result case Success(data: final location)) {
      _currentLocation = location;
      emit(LocationLoaded(locationData: location));
    } else if (result case Failure(:final message)) {
      emit(SafetyCompassError(message: message));
    }
  }

  void _startCompassStream() {
    _compassSubscription?.cancel();
    _compassSubscription = _getCompassHeadingUseCase().listen((compassData) {
      emit(CompassUpdated(
        compassData: compassData,
        locationData: _currentLocation,
      ));
    });
  }

  @override
  Future<void> close() {
    _compassSubscription?.cancel();
    return super.close();
  }
}

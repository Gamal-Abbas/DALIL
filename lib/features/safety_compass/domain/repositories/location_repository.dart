import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/safety_compass/domain/entities/location_data.dart';

abstract class LocationRepository {
  Future<Result<bool>> checkAndRequestPermission();
  Future<Result<bool>> isGpsEnabled();
  Future<Result<LocationData>> getCurrentLocation();
}

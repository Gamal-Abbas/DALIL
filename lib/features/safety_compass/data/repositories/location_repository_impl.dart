import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/safety_compass/data/datasources/location_data_source.dart';
import 'package:dalil/features/safety_compass/domain/entities/location_data.dart';
import 'package:dalil/features/safety_compass/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;

  LocationRepositoryImpl(this._dataSource);

  @override
  Future<Result<bool>> checkAndRequestPermission() async {
    try {
      final hasPermission = await _dataSource.checkAndRequestPermission();
      return Success(hasPermission);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<bool>> isGpsEnabled() async {
    try {
      final isEnabled = await _dataSource.isGpsEnabled();
      return Success(isEnabled);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<LocationData>> getCurrentLocation() async {
    try {
      final data = await _dataSource.getCurrentPosition();
      return Success(LocationData(
        latitude: data['latitude']!,
        longitude: data['longitude']!,
        accuracy: data['accuracy']!,
      ));
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/safety_compass/domain/entities/location_data.dart';
import 'package:dalil/features/safety_compass/domain/repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository _repository;

  GetCurrentLocationUseCase(this._repository);

  Future<Result<LocationData>> call() async {
    return await _repository.getCurrentLocation();
  }
}

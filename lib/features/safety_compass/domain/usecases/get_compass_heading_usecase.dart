import 'package:dalil/features/safety_compass/domain/entities/compass_data.dart';
import 'package:dalil/features/safety_compass/domain/repositories/compass_repository.dart';

class GetCompassHeadingUseCase {
  final CompassRepository _repository;

  GetCompassHeadingUseCase(this._repository);

  Stream<CompassData> call() {
    return _repository.getHeadingStream();
  }
}

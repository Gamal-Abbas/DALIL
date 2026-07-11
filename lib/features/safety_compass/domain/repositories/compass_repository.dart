import 'package:dalil/features/safety_compass/domain/entities/compass_data.dart';

abstract class CompassRepository {
  Stream<CompassData> getHeadingStream();
}

import 'package:dalil/features/safety_compass/data/datasources/compass_data_source.dart';
import 'package:dalil/features/safety_compass/domain/entities/compass_data.dart';
import 'package:dalil/features/safety_compass/domain/repositories/compass_repository.dart';

class CompassRepositoryImpl implements CompassRepository {
  final CompassDataSource _dataSource;

  CompassRepositoryImpl(this._dataSource);

  @override
  Stream<CompassData> getHeadingStream() {
    return _dataSource.getHeadingStream().map((heading) {
      return CompassData(
        heading: heading,
        direction: _headingToDirection(heading),
      );
    });
  }

  String _headingToDirection(double heading) {
    if (heading >= 337.5 || heading < 22.5) return 'North';
    if (heading >= 22.5 && heading < 67.5) return 'North East';
    if (heading >= 67.5 && heading < 112.5) return 'East';
    if (heading >= 112.5 && heading < 157.5) return 'South East';
    if (heading >= 157.5 && heading < 202.5) return 'South';
    if (heading >= 202.5 && heading < 247.5) return 'South West';
    if (heading >= 247.5 && heading < 292.5) return 'West';
    return 'North West';
  }
}

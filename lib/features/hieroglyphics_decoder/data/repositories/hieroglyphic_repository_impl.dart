import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/hieroglyphics_decoder/data/datasources/model_local_datasource.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/detected_symbol.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/repositories/hieroglyphic_repository.dart';

class HieroglyphicRepositoryImpl implements HieroglyphicRepository {
  final ModelLocalDataSource _dataSource;

  HieroglyphicRepositoryImpl(this._dataSource);

  @override
  Future<Result<void>> loadModel() async {
    try {
      await _dataSource.loadModel();
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<DetectedSymbol>>> detectSymbols(String imagePath) async {
    try {
      final detections = _dataSource.detect(imagePath);
      return Success(detections);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  void dispose() {
    _dataSource.dispose();
  }
}

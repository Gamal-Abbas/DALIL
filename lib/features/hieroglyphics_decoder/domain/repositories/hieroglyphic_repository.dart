import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/detected_symbol.dart';

abstract class HieroglyphicRepository {
  Future<Result<void>> loadModel();
  Future<Result<List<DetectedSymbol>>> detectSymbols(String imagePath);
  void dispose();
}

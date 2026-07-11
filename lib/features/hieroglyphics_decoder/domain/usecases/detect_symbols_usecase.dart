import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/detected_symbol.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/repositories/hieroglyphic_repository.dart';

class DetectSymbolsUseCase {
  final HieroglyphicRepository _repository;

  DetectSymbolsUseCase(this._repository);

  Future<Result<List<DetectedSymbol>>> call(String imagePath) async {
    return await _repository.detectSymbols(imagePath);
  }
}

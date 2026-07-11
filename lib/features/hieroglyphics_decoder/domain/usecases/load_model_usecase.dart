import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/repositories/hieroglyphic_repository.dart';

class LoadModelUseCase {
  final HieroglyphicRepository _repository;

  LoadModelUseCase(this._repository);

  Future<Result<void>> call() async {
    return await _repository.loadModel();
  }
}

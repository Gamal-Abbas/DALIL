import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/hieroglyphic_symbol.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/repositories/symbol_details_repository.dart';

class GetSymbolDetailsUseCase {
  final SymbolDetailsRepository _repository;

  GetSymbolDetailsUseCase(this._repository);

  Future<Result<HieroglyphicSymbol>> call(String id) async {
    return await _repository.getSymbolById(id);
  }
}

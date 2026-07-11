import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/hieroglyphic_symbol.dart';

abstract class SymbolDetailsRepository {
  Future<Result<List<HieroglyphicSymbol>>> getAllSymbols();
  Future<Result<HieroglyphicSymbol>> getSymbolById(String id);
}

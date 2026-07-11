import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/hieroglyphics_decoder/data/datasources/json_local_datasource.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/hieroglyphic_symbol.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/repositories/symbol_details_repository.dart';

class SymbolDetailsRepositoryImpl implements SymbolDetailsRepository {
  final JsonLocalDataSource _dataSource;

  SymbolDetailsRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<HieroglyphicSymbol>>> getAllSymbols() async {
    try {
      final symbols = await _dataSource.loadSymbols();
      return Success(symbols);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<HieroglyphicSymbol>> getSymbolById(String id) async {
    try {
      final symbol = await _dataSource.findById(id);
      if (symbol == null) {
        return const Failure('Symbol not found');
      }
      return Success(symbol);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

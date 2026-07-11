import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dalil/features/hieroglyphics_decoder/data/models/hieroglyphic_symbol_model.dart';

class JsonLocalDataSource {
  List<HieroglyphicSymbolModel>? _cachedSymbols;

  Future<List<HieroglyphicSymbolModel>> loadSymbols() async {
    if (_cachedSymbols != null) return _cachedSymbols!;

    final jsonString = await rootBundle.loadString('assets/data/hieroglyphics.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    _cachedSymbols = jsonList
        .map((json) => HieroglyphicSymbolModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return _cachedSymbols!;
  }

  Future<HieroglyphicSymbolModel?> findById(String id) async {
    final symbols = await loadSymbols();
    try {
      return symbols.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}

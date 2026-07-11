import 'package:dalil/features/hieroglyphics_decoder/domain/entities/hieroglyphic_symbol.dart';

class HieroglyphicSymbolModel extends HieroglyphicSymbol {
  const HieroglyphicSymbolModel({
    required super.id,
    required super.english,
    required super.pronunciation,
    required super.meaning,
    required super.arabic,
    required super.description,
  });

  factory HieroglyphicSymbolModel.fromJson(Map<String, dynamic> json) {
    return HieroglyphicSymbolModel(
      id: json['id'] as String,
      english: json['english'] as String,
      pronunciation: json['pronunciation'] as String,
      meaning: json['meaning'] as String,
      arabic: json['arabic'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'pronunciation': pronunciation,
      'meaning': meaning,
      'arabic': arabic,
      'description': description,
    };
  }
}

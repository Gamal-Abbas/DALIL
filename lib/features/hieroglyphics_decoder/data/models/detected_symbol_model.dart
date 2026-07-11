import 'package:dalil/features/hieroglyphics_decoder/domain/entities/detected_symbol.dart';

class DetectedSymbolModel extends DetectedSymbol {
  const DetectedSymbolModel({
    required super.label,
    required super.confidence,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
  });

  factory DetectedSymbolModel.fromDetection({
    required String label,
    required double confidence,
    required double x,
    required double y,
    required double width,
    required double height,
  }) {
    return DetectedSymbolModel(
      label: label,
      confidence: confidence,
      x: x,
      y: y,
      width: width,
      height: height,
    );
  }
}

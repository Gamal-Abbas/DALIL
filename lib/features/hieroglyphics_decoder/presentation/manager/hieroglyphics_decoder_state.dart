import 'dart:io';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/detected_symbol.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/hieroglyphic_symbol.dart';

sealed class HieroglyphicsDecoderState {
  const HieroglyphicsDecoderState();
}

final class Initial extends HieroglyphicsDecoderState {
  const Initial();
}

final class LoadingModel extends HieroglyphicsDecoderState {
  const LoadingModel();
}

final class Ready extends HieroglyphicsDecoderState {
  const Ready();
}

final class Processing extends HieroglyphicsDecoderState {
  const Processing();
}

final class DecoderSuccess extends HieroglyphicsDecoderState {
  final File imageFile;
  final List<DetectedSymbol> detections;
  final Map<String, HieroglyphicSymbol> symbolDetails;

  const DecoderSuccess({
    required this.imageFile,
    required this.detections,
    required this.symbolDetails,
  });
}

final class DecoderError extends HieroglyphicsDecoderState {
  final String message;

  const DecoderError({required this.message});
}

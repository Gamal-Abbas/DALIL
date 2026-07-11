import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil/core/result/result.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/hieroglyphic_symbol.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/usecases/load_model_usecase.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/usecases/detect_symbols_usecase.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/usecases/get_symbol_details_usecase.dart';
import 'package:dalil/features/hieroglyphics_decoder/presentation/manager/hieroglyphics_decoder_state.dart';

class HieroglyphicsDecoderCubit extends Cubit<HieroglyphicsDecoderState> {
  final LoadModelUseCase _loadModelUseCase;
  final DetectSymbolsUseCase _detectSymbolsUseCase;
  final GetSymbolDetailsUseCase _getSymbolDetailsUseCase;

  HieroglyphicsDecoderCubit({
    required LoadModelUseCase loadModelUseCase,
    required DetectSymbolsUseCase detectSymbolsUseCase,
    required GetSymbolDetailsUseCase getSymbolDetailsUseCase,
  })  : _loadModelUseCase = loadModelUseCase,
        _detectSymbolsUseCase = detectSymbolsUseCase,
        _getSymbolDetailsUseCase = getSymbolDetailsUseCase,
        super(const Initial());

  Future<void> initializeModel() async {
    emit(const LoadingModel());
    final result = await _loadModelUseCase();
    if (result case Success()) {
      emit(const Ready());
    } else if (result case Failure(:final message)) {
      emit(DecoderError(message: message));
    }
  }

  Future<void> processImage(File imageFile) async {
    emit(const Processing());
    try {
      final result = await _detectSymbolsUseCase(imageFile.path);
      if (result case Success(data: final detections)) {
        final detailsMap = <String, HieroglyphicSymbol>{};
        for (final detection in detections) {
          final detailResult = await _getSymbolDetailsUseCase(detection.label);
          if (detailResult case Success(data: final symbol)) {
            detailsMap[detection.label] = symbol;
          }
        }
        emit(DecoderSuccess(
          imageFile: imageFile,
          detections: detections,
          symbolDetails: detailsMap,
        ));
      } else if (result case Failure(:final message)) {
        emit(DecoderError(message: message));
      }
    } catch (e) {
      emit(DecoderError(message: e.toString()));
    }
  }

  void reset() {
    emit(const Ready());
  }
}

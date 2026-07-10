import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/usecases/generate_guide_usecase.dart';
import 'ai_guide_state.dart';

class AiGuideCubit extends Cubit<AiGuideState> {
  final GenerateGuideUseCase generateGuideUseCase;
  final FlutterTts flutterTts;
  
  StreamSubscription<Position>? _positionSubscription;
  bool _isSpeaking = false;

  bool _ttsInitialized = false;

  AiGuideCubit({
    required this.generateGuideUseCase,
    required this.flutterTts,
  }) : super(AiGuideInitial()) {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setSharedInstance(true);
    await flutterTts.awaitSpeakCompletion(true);
    
    await Future.delayed(const Duration(seconds: 1));

    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);

    await Future.delayed(const Duration(milliseconds: 500));
    
    _ttsInitialized = true;
    
    flutterTts.setStartHandler(() {
      // TTS started
    });

    flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      if (!isClosed) {
        emit(AiGuideSearching());
      }
    });

    flutterTts.setCancelHandler(() {
      // TTS cancelled
    });

    flutterTts.setErrorHandler((message) {
      // TTS error
    });
  }

  Future<void> startListening() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          emit(AiGuideError("Location permission denied. Cannot guide."));
          return;
        }
      }

      emit(AiGuideSearching());

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen(
        (Position position) => _handleLocationUpdate(position),
        onError: (error) {
          emit(AiGuideError("Location error: $error"));
        },
      );
    } catch (e) {
      emit(AiGuideError("Failed to start guide: $e"));
    }
  }

  Future<void> _handleLocationUpdate(Position position) async {
    if (!_ttsInitialized) {
      return;
    }
    
    if (_isSpeaking) {
      return;
    }

    try {
      final response = await generateGuideUseCase(
        GenerateGuideParams(
          currentLatitude: position.latitude,
          currentLongitude: position.longitude,
          onPlaceDetected: (place) {
            emit(AiGuideGenerating(place));
          },
        ),
      );

      if (response == null) {
        if (state is! AiGuideSearching && !_isSpeaking && state is! AiGuideGenerating) {
          emit(AiGuideSearching());
        }
        return;
      }

      // We have a guide response!
      _isSpeaking = true;
      
      emit(AiGuideSpeaking(place: response.place, guide: response.generatedGuide));
      
      await flutterTts.speak(response.generatedGuide);
      
    } catch (e) {
      _isSpeaking = false;
      emit(AiGuideError("Guide error: $e"));
    }
  }

  Future<void> pause() async {
    if (state is AiGuideSpeaking) {
      final currentState = state as AiGuideSpeaking;
      
      emit(AiGuideSpeaking(
        place: currentState.place,
        guide: currentState.guide,
        isPaused: true,
      ));
      
      await flutterTts.pause();
    }
  }

  Future<void> resume() async {
    if (state is AiGuideSpeaking) {
      final currentState = state as AiGuideSpeaking;
      
      emit(AiGuideSpeaking(
        place: currentState.place,
        guide: currentState.guide,
        isPaused: false,
      ));
      
      await flutterTts.speak(currentState.guide);
    }
  }

  Future<void> scanAgain() async {
    await flutterTts.stop();
    _isSpeaking = false;
    
    generateGuideUseCase.resetLastExplainedPlace();
    
    emit(AiGuideSearching());
    
    await _positionSubscription?.cancel();
    
    startListening();
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    flutterTts.stop();
    return super.close();
  }
}

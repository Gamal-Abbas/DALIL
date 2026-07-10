import '../../domain/entities/guide_place_entity.dart';

abstract class AiGuideState {}

class AiGuideInitial extends AiGuideState {}

class AiGuideSearching extends AiGuideState {}

class AiGuideGenerating extends AiGuideState {
  final GuidePlaceEntity place;

  AiGuideGenerating(this.place);
}

class AiGuideSpeaking extends AiGuideState {
  final GuidePlaceEntity place;
  final String guide;
  final bool isPaused;

  AiGuideSpeaking({
    required this.place,
    required this.guide,
    this.isPaused = false,
  });
}

class AiGuideError extends AiGuideState {
  final String message;

  AiGuideError(this.message);
}

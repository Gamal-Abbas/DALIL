import 'guide_place_entity.dart';

class GuideResponse {
  final GuidePlaceEntity place;
  final String generatedGuide;

  const GuideResponse({
    required this.place,
    required this.generatedGuide,
  });
}

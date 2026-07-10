import '../entities/guide_place_entity.dart';

abstract class GuideRepository {
  Future<List<GuidePlaceEntity>> getAllPlaces();
  Future<String> generateGuide(String prompt);
}

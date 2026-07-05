import '../entities/place_entity.dart';

abstract class PlaceRepository {
  Future<List<PlaceEntity>> getPlacesByCity(String cityId);
}

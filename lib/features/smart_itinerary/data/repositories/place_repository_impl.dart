import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_remote_data_source.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;

  PlaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PlaceEntity>> getPlacesByCity(String cityId) async {
    try {
      final places = await remoteDataSource.getPlacesByCity(cityId);
      // PlaceModel extends PlaceEntity, so we can return them directly
      return places;
    } catch (e) {
      // Passes the exception upwards.
      // If a custom Failure class is introduced later, map it here.
      rethrow;
    }
  }
}

import '../../domain/entities/guide_place_entity.dart';
import '../../domain/repositories/guide_repository.dart';
import '../datasources/guide_remote_data_source.dart';

class GuideRepositoryImpl implements GuideRepository {
  final GuideRemoteDataSource remoteDataSource;

  GuideRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<GuidePlaceEntity>> getAllPlaces() async {
    return await remoteDataSource.getAllPlaces();
  }

  @override
  Future<String> generateGuide(String prompt) async {
    return await remoteDataSource.generateGuide(prompt);
  }
}

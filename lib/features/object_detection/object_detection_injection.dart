import 'package:get_it/get_it.dart';
import 'data/datasources/object_detection_local_data_source.dart';
import 'data/repositories/object_detection_repository_impl.dart';
import 'domain/repositories/object_detection_repository.dart';
import 'presentation/cubit/object_detection_cubit.dart';

final sl = GetIt.instance;

void initObjectDetection() {
  // Cubit
  sl.registerFactory(() => ObjectDetectionCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<ObjectDetectionRepository>(
    () => ObjectDetectionRepositoryImpl(localDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<ObjectDetectionLocalDataSource>(
    () => ObjectDetectionLocalDataSourceImpl(),
  );
}

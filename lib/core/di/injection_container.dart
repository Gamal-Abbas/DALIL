import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/smart_itinerary/data/datasources/place_remote_data_source.dart';
import '../../features/smart_itinerary/data/repositories/place_repository_impl.dart';
import '../../features/smart_itinerary/domain/repositories/place_repository.dart';
import '../../features/smart_itinerary/domain/usecases/generate_itinerary_usecase.dart';
import '../../features/smart_itinerary/presentation/cubit/smart_itinerary_cubit.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // ! Features - (e.g., Auth, Landmarks, etc.)
  // Data sources
  sl.registerLazySingleton<PlaceRemoteDataSource>(
      () => PlaceRemoteDataSourceImpl(firestore: sl()));
  
  // Repositories
  sl.registerLazySingleton<PlaceRepository>(
      () => PlaceRepositoryImpl(remoteDataSource: sl()));
  
  // Use cases
  sl.registerLazySingleton(() => GenerateItineraryUseCase(sl()));
  
  // Blocs / Providers / Cubits
  sl.registerFactory(() => SmartItineraryCubit(generateItineraryUseCase: sl()));

  // ! Core
  // Network, Local Storage, etc.

  // ! External
  // Shared Preferences, HTTP client, Dio, Firebase, etc.
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}

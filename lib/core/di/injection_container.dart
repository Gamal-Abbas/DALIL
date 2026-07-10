import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/smart_itinerary/data/datasources/place_remote_data_source.dart';
import '../../features/smart_itinerary/data/repositories/place_repository_impl.dart';
import '../../features/smart_itinerary/domain/repositories/place_repository.dart';
import '../../features/smart_itinerary/domain/usecases/generate_itinerary_usecase.dart';
import '../../features/smart_itinerary/presentation/cubit/smart_itinerary_cubit.dart';

// AI Guide Feature
import '../../features/ai_guide/data/datasources/guide_remote_data_source.dart';
import '../../features/ai_guide/data/repositories/guide_repository_impl.dart';
import '../../features/ai_guide/domain/repositories/guide_repository.dart';
import '../../features/ai_guide/domain/usecases/generate_guide_usecase.dart';
import '../../features/ai_guide/presentation/cubit/ai_guide_cubit.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  
  sl.registerFactory(() => SmartItineraryCubit(generateItineraryUseCase: sl()));

  // AI Guide Feature
  sl.registerLazySingleton<GuideRemoteDataSource>(() => GuideRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<GuideRepository>(() => GuideRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GenerateGuideUseCase(sl()));
  sl.registerFactory(() => AiGuideCubit(generateGuideUseCase: sl(), flutterTts: sl()));

  // ! Core
  // Network, Local Storage, etc.

  // ! External
  // Shared Preferences, HTTP client, Dio, Firebase, etc.
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FlutterTts());
}

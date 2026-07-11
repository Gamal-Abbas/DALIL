import 'package:get_it/get_it.dart';
import 'package:dalil/features/hieroglyphics_decoder/data/datasources/model_local_datasource.dart';
import 'package:dalil/features/hieroglyphics_decoder/data/datasources/json_local_datasource.dart';
import 'package:dalil/features/hieroglyphics_decoder/data/repositories/hieroglyphic_repository_impl.dart';
import 'package:dalil/features/hieroglyphics_decoder/data/repositories/symbol_details_repository_impl.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/repositories/hieroglyphic_repository.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/repositories/symbol_details_repository.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/usecases/load_model_usecase.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/usecases/detect_symbols_usecase.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/usecases/get_symbol_details_usecase.dart';
import 'package:dalil/features/hieroglyphics_decoder/presentation/manager/hieroglyphics_decoder_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Hieroglyphics Decoder

  // Data sources
  sl.registerLazySingleton<ModelLocalDataSource>(
    () => ModelLocalDataSource(),
  );
  sl.registerLazySingleton<JsonLocalDataSource>(
    () => JsonLocalDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<HieroglyphicRepository>(
    () => HieroglyphicRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SymbolDetailsRepository>(
    () => SymbolDetailsRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton<LoadModelUseCase>(
    () => LoadModelUseCase(sl()),
  );
  sl.registerLazySingleton<DetectSymbolsUseCase>(
    () => DetectSymbolsUseCase(sl()),
  );
  sl.registerLazySingleton<GetSymbolDetailsUseCase>(
    () => GetSymbolDetailsUseCase(sl()),
  );

  // Cubits
  sl.registerFactory<HieroglyphicsDecoderCubit>(
    () => HieroglyphicsDecoderCubit(
      loadModelUseCase: sl(),
      detectSymbolsUseCase: sl(),
      getSymbolDetailsUseCase: sl(),
    ),
  );

  // ! Core
  // Network, Local Storage, etc.

  // ! External
  // Shared Preferences, HTTP client, Dio, Firebase, etc.
}

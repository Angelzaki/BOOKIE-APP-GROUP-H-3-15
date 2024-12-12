import 'package:bookieapp/data/repository/auth_repository_impl.dart';
import 'package:bookieapp/data/repository/story_repository_impl.dart';
import 'package:bookieapp/data/source/auth_data.dart';
import 'package:bookieapp/data/source/library_data.dart';
import 'package:bookieapp/data/source/network/api.dart';
import 'package:bookieapp/domain/repository/auth_repository.dart';
import 'package:bookieapp/domain/repository/story_repository.dart';
import 'package:bookieapp/domain/use_cases/check_login.dart';
import 'package:bookieapp/domain/use_cases/get_all_stories.dart';
import 'package:bookieapp/domain/use_cases/logout_case.dart';
import 'package:bookieapp/domain/use_cases/send_id_token.dart';
import 'package:bookieapp/ui/store/auth/auth_store.dart';
import 'package:bookieapp/ui/store/story/story_store.dart';
// import 'package:bookieapp/ui/store/main_store.dart';
import 'package:get_it/get_it.dart';
import '../data/source/network/google_singin_api.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Registra las dependencias de la capa de datos
  sl.registerLazySingleton<GoogleSingInApi>(() => GoogleSingInApi());
  sl.registerLazySingleton<Api>(() => Api());
  sl.registerLazySingleton<AuthDataSourceImpl>(()=> AuthDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authDataSourceImpl: sl()));
  sl.registerLazySingleton<StoryDataSourceImpl>(() => StoryDataSourceImpl(sl()));
  sl.registerLazySingleton<StoryRepository>(() => StoryRepositoryImpl(storyDataSourceImpl: sl()));

  // Capa de dominio
  sl.registerLazySingleton(() => SendIdToken(sl()));
  sl.registerLazySingleton(() => CheckLoginStatusUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerLazySingleton(() => GetAllStories(sl()));
  // Registra las tiendas de UI
  // Asegúrate de que MainStore se registre primero porque AuthStore depende de él
  // sl.registerLazySingleton(() => MainStore());
  sl.registerLazySingleton(() => AuthStore(main: sl(), sendTokenUseCase: sl(), checkLoginStatusUseCase: sl(), logOutUseCase:sl()));
  sl.registerLazySingleton(() => StoryStore(main: sl(), getAllStories: sl()));
}

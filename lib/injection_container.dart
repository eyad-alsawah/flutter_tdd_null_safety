import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tdd/core/network/network_info.dart';
import 'package:tdd/core/utils/input_converter.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:tdd/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

// service locator == injection container
final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator.registerFactory(
    //! Feautures
    // Bloc
    () => NumberTriviaBloc(
      // because GetIt is a callable class we can simply use serviceLocator instead of serviceLocator.call
      getConcreteNumberTriviaUseCase: serviceLocator(),
      getRandomNumberTriviaUseCase: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton(
      () => GetConcreteNumberTriviaUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetRandomNumberTriviaUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImplementation(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Data Sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImplementation(
        httpClient: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(() =>
      NumberTriviaLocalDataSourceImplementation(
          sharedPreferences: serviceLocator()));

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplementation(serviceLocator()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}

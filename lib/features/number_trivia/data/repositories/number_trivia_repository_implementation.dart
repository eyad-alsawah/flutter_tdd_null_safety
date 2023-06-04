import 'package:tdd/core/errors/exceptions.dart';
import 'package:tdd/core/platform/network_info.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOrRandom = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImplementation implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImplementation(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return await _getNumberTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number) async {
    return await _getNumberTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  // higher order function (a function that takes a function as a parameter or returns a function)
  Future<Either<Failure, NumberTriviaEntity>> _getNumberTrivia(
      _ConcreteOrRandom getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final NumberTriviaEntity remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final NumberTriviaEntity localTrivia =
            await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:tdd/core/errors/exceptions.dart';
import 'package:tdd/core/errors/failures.dart';
import 'package:tdd/core/platform/network_info.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';

import 'number_trivia_repository_implementation_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(),
  MockSpec<NumberTriviaLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
void main() {
  late NumberTriviaRepositoryImplementation repositoryImplementation;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImplementation = NumberTriviaRepositoryImplementation(
      localDataSource: mockNumberTriviaLocalDataSource,
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('get concrete number trivia ', () {
    const tNumber = 1;
    const NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'text trivia model');
    // the model will be casted as an entity because it subclasses it
    const NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImplementation.getConcreteNumberTrivia(tNumber);
      // assert

      // verifies that the isConnected getter has been called
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return entity when the call to remote data source is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTriviaEntity)));
      });

      test(
          'should cache the entity when the call to remote data source is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act

        await repositoryImplementation.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // act

        final result =
            await repositoryImplementation.getConcreteNumberTrivia(tNumber);
        // assert
        verify(await mockNumberTriviaRemoteDataSource
            .getConcreteNumberTrivia(tNumber));
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached entity when the cached data is present ',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(tNumber);

        // assert

        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        expect(result, equals(const Right(tNumberTriviaEntity)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result =
            await repositoryImplementation.getConcreteNumberTrivia(tNumber);

        // assert

        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('get random number trivia ', () {
    const NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'text trivia model');
    // the model will be casted as an entity because it subclasses it
    const NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImplementation.getRandomNumberTrivia();
      // assert

      // verifies that the isConnected getter has been called
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return entity when the call to remote data source is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repositoryImplementation.getRandomNumberTrivia();
        // assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTriviaEntity)));
      });

      test(
          'should cache the entity when the call to remote data source is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act

        await repositoryImplementation.getRandomNumberTrivia();
        // assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act

        final result = await repositoryImplementation.getRandomNumberTrivia();
        // assert
        verify(await mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached entity when the cached data is present ',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repositoryImplementation.getRandomNumberTrivia();

        // assert

        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        expect(result, equals(const Right(tNumberTriviaEntity)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repositoryImplementation.getRandomNumberTrivia();

        // assert

        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}

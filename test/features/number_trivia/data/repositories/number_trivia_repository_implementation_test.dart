import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:tdd/core/platform/network_info.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:tdd/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';

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
    repositoryImplementation = NumberTriviaRepositoryImplementation(
      localDataSource: mockNumberTriviaLocalDataSource,
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
  });
}

import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tdd/core/errors/exceptions.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'numbre_trivia_remote_data_sources_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late NumberTriviaRemoteDataSourceImplementation
      remoteDataSourceImplementation;
  late MockClient mockHttpClient;
  setUp(
    () {
      mockHttpClient = MockClient();
      remoteDataSourceImplementation =
          NumberTriviaRemoteDataSourceImplementation(
              httpClient: mockHttpClient);
    },
  );
  void setUpMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(getFixture('trivia_int.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something Went Wrong', 404));
  }

  group('getConcrete Number trivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(getFixture('trivia_int.json')));
    test('''should perform a GET request on a URL with number 
        being the endpoint and with application/json header''', () async {
      // arrange
      setUpMockHttpClientSuccess();
      // act
      remoteDataSourceImplementation.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json,'}));
    });

    test('should return NumberTriviaModel when the response code is 200',
        () async {
      // arrange
      setUpMockHttpClientSuccess();
      // act
      final result =
          await remoteDataSourceImplementation.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a server exception when the response code is not 200',
        () async {
      // arrange
      setUpMockHttpClientFailure();
      // act
      final call = remoteDataSourceImplementation.getConcreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}

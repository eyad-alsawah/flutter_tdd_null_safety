import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd/core/errors/exceptions.dart';
import 'package:tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixtures_reader.dart';
import 'number_trivia_local_data_source.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  late NumberTriviaLocalDataSourceImplementation
      numberTriviaLocalDataSourceImplementation;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImplementation =
        NumberTriviaLocalDataSourceImplementation(
            sharedPreferences: mockSharedPreferences);
  });

  group('get last number trivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(getFixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(getFixture('trivia_cached.json'));
      // act
      final result =
          await numberTriviaLocalDataSourceImplementation.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw CacheException when there is not a cached value',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      // reference to a function
      final call =
          numberTriviaLocalDataSourceImplementation.getLastNumberTrivia;
      // assert
      //excepting that calling last number trivia throws an exception
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}

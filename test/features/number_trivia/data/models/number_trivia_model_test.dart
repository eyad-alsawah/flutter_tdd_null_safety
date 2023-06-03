import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  late NumberTriviaModel tNumberTriviaModel;

  setUp(() {
    tNumberTriviaModel =
        const NumberTriviaModel(number: 1, text: "model test text");
  });

  test('Number Trivia Model should be a subclass of number trivia entity',
      () async {
    // arrange
    // act
    // assert
    expect(tNumberTriviaModel, isA<NumberTriviaEntity>());
  });

  group('fromJson', () {
    test(
        'should return a valid NumberTriviaModel when the JSON number is of type integer',
        () {
      // arrange
      //
      late Map<String, dynamic> jsonMap =
          json.decode(getFixture('trivia_int.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, isA<NumberTriviaModel>());
    });

    test(
        'should return a valid NumberTriviaModel when the JSON number is of type double',
        () {
      // arrange
      //
      late Map<String, dynamic> jsonMap =
          json.decode(getFixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, isA<NumberTriviaModel>());
    });
  });

  group('toJson', () {
    test('should return a Map<String,dynamic> containing the proper data', () {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectedMap = {
        "text":
            "7e+22 is the number of stars within range of telescopes (as of 2003).",
        "number": 7e+22,
      };
      expect(result, expectedMap);
    });
  });
}

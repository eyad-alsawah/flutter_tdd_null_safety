import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';

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
}

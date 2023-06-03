import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  const NumberTriviaModel({required int number, required String text})
      : super(number: number, text: text);
}

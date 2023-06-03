import 'package:tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

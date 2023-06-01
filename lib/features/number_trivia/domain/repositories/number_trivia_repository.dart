
import 'package:dartz/dartz.dart';
import 'package:tdd/core/errors/failures.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number);
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia();
}

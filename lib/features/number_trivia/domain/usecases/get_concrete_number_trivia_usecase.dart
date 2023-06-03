import 'package:dartz/dartz.dart';
import 'package:tdd/core/errors/failures.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTriviaUseCase(this.numberTriviaRepository);

  Future<Either<Failure, NumberTriviaEntity>> call(
      {required int number}) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(number);
  }
}

import 'package:dartz/dartz.dart';

import 'package:tdd/core/errors/failures.dart';
import 'package:tdd/core/usecases/usecase.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUseCase
    implements UseCase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetRandomNumberTriviaUseCase(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(
      {required NoParams params}) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}

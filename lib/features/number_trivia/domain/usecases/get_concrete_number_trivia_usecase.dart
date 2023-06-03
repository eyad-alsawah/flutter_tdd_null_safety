import 'package:dartz/dartz.dart';
import 'package:tdd/core/errors/failures.dart';
import 'package:tdd/core/usecases/usecase.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase
    implements UseCase<NumberTriviaEntity, Params> {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTriviaUseCase(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(
      {required Params params}) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

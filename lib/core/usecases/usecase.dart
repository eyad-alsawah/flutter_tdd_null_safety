import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd/core/errors/failures.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, NumberTriviaEntity>> call({required Params params});
}

class Params extends Equatable {
  final int number;
  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}

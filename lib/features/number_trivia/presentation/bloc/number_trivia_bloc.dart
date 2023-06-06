import 'package:bloc/bloc.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd/core/errors/failures.dart';
import 'package:tdd/core/usecases/usecase.dart';
import 'package:tdd/core/utils/input_converter.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'server failure';
const String CACHE_FAILURE_MESSAGE = 'cache failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input the number must be a positive integer or zero ';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTriviaUseCase,
      required this.getRandomNumberTriviaUseCase,
      required this.inputConverter})
      : super(EmptyNumberTriviaState()) {
    on<GetTriviaForConcreteNumber>((event, emit) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      // accepts two higher order functions

      inputEither.fold((failure) async {
        emit(const ErrorNumberTriviaState(
            message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (integer) async {
        emit(LoadingNumberTriviaState());
        final failureOrTrivia = await getConcreteNumberTriviaUseCase(
            params: Params(number: integer));
        // yield* is a delegate to another yield
        emit(failureOrTrivia.fold(
            (failure) =>
                ErrorNumberTriviaState(message: _mapFailureToMessage(failure)),
            (trivia) => LoadedNumberTriviaState(numberTriviaEntity: trivia)));
      });
    });
    // ignore: void_checks
    on<GetRandomTriviaForRandomNumber>((event, emit) async {
      emit(LoadingNumberTriviaState());
      final failureOrTrivia =
          await getRandomNumberTriviaUseCase(params: NoParams());
      emit(failureOrTrivia.fold(
          (failure) =>
              ErrorNumberTriviaState(message: _mapFailureToMessage(failure)),
          (trivia) => LoadedNumberTriviaState(numberTriviaEntity: trivia)));
    });
  }

  Stream<NumberTriviaState> _eitherFailureOrLoadedState(
      Emitter<NumberTriviaState> emit,
      Either<Failure, NumberTriviaEntity> failureOrTrivia) async* {}
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected Error';
  }
}

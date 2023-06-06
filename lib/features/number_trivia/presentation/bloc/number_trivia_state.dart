part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class EmptyNumberTriviaState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class LoadingNumberTriviaState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class LoadedNumberTriviaState extends NumberTriviaState {
  final NumberTriviaEntity numberTriviaEntity;

  const LoadedNumberTriviaState({required this.numberTriviaEntity});

  @override
  List<Object> get props => [numberTriviaEntity];
}

class ErrorNumberTriviaState extends NumberTriviaState {
  final String message;

  const ErrorNumberTriviaState({required this.message});
  @override
  List<Object> get props => [message];
}

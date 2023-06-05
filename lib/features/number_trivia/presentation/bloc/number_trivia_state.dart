part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class EmptyNumberTriviaState extends NumberTriviaState {}

class LoadingNumberTriviaState extends NumberTriviaState {}

class LoadedNumberTriviaState extends NumberTriviaState {
  final NumberTriviaEntity numberTriviaEntity;

  const LoadedNumberTriviaState({required this.numberTriviaEntity});
}

class ErrorNumberTriviaState extends NumberTriviaState {
  final String message;

  const ErrorNumberTriviaState({required this.message});
}

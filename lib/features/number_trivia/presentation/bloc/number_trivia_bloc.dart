import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc() : super(EmptyNumberTriviaState()) {
    on<NumberTriviaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

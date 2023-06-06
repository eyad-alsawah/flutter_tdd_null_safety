import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/core/errors/failures.dart';
import 'package:tdd/core/usecases/usecase.dart';
import 'package:tdd/core/utils/input_converter.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTriviaUseCase>(),
  MockSpec<GetRandomNumberTriviaUseCase>(),
  MockSpec<InputConverter>()
])
void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTriviaUseCase mockGetConcreteNumberTriviaUseCase;
  late MockGetRandomNumberTriviaUseCase mockGetRandomNumberTriviaUseCase;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTriviaUseCase = MockGetConcreteNumberTriviaUseCase();
    mockGetRandomNumberTriviaUseCase = MockGetRandomNumberTriviaUseCase();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
        getConcreteNumberTriviaUseCase: mockGetConcreteNumberTriviaUseCase,
        getRandomNumberTriviaUseCase: mockGetRandomNumberTriviaUseCase,
        inputConverter: mockInputConverter);
  });

  test('initial state should be EmptyNumberTriviaState', () {
    // assert
    expect(numberTriviaBloc.state, equals(EmptyNumberTriviaState()));
  });

  group('get Trivia for concrete number', () {
    const tNumberString = "1";
    const tNumberConverted = 1;
    const tNumberTriviaEntity =
        NumberTriviaEntity(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberConverted));

    test(
        'should call the input converter to validate and convert the string to an unsigned integer',
        () async* {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      numberTriviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));

      // pausing the execution until stringToUnsignedInteger method is called
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [ErrorNumberTriviaState] when the input is invalid',
        () async* {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      // assert later
      List<NumberTriviaState> expectedStates = [
        EmptyNumberTriviaState(),
        const ErrorNumberTriviaState(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expectedStates));

      // act

      // dispatching an event after calling expectLater to make sure that execution doesn't finish faster before we have the chance to register our expectations
      numberTriviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete usecase', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTriviaUseCase(
              params: const Params(number: tNumberConverted)))
          .thenAnswer((_) async => const Right(tNumberTriviaEntity));
      // act
      numberTriviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTriviaUseCase(
          params: const Params(number: tNumberConverted)));

      // assert
      verify(mockGetConcreteNumberTriviaUseCase(
          params: const Params(number: tNumberConverted)));
    });

    // use async* instead of async for streams
    test(
        'should emit [LoadingState, DoneState] when data is gotten successfully',
        () async* {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTriviaUseCase(
              params: const Params(number: tNumberConverted)))
          .thenAnswer((_) async => const Right(tNumberTriviaEntity));
      // assert later
      final excepted = [
        EmptyNumberTriviaState(),
        LoadingNumberTriviaState(),
        const LoadedNumberTriviaState(numberTriviaEntity: tNumberTriviaEntity)
      ];
      // just like above we wait until our expectations are registered, only then we dispatch an event to the bloc
      expectLater(numberTriviaBloc.stream, emitsInOrder(excepted));
      // act
      numberTriviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [LoadingState, ErrorState] when getting data fails',
        () async* {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTriviaUseCase(
              params: const Params(number: tNumberConverted)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final excepted = [
        EmptyNumberTriviaState(),
        LoadingNumberTriviaState(),
        const ErrorNumberTriviaState(message: SERVER_FAILURE_MESSAGE)
      ];
      // just like above we wait until our expectations are registered, only then we dispatch an event to the bloc
      expectLater(numberTriviaBloc.stream, emitsInOrder(excepted));
      // act
      numberTriviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [LoadingState, ErrorState] with proper message for the error when getting data fails',
        () async* {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTriviaUseCase(
              params: const Params(number: tNumberConverted)))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final excepted = [
        EmptyNumberTriviaState(),
        LoadingNumberTriviaState(),
        const ErrorNumberTriviaState(message: CACHE_FAILURE_MESSAGE)
      ];

      // just like above we wait until our expectations are registered, only then we dispatch an event to the bloc
      expectLater(numberTriviaBloc.stream, emitsInOrder(excepted));
      // act
      numberTriviaBloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('get Trivia for random number', () {
    const tNumberTriviaEntity =
        NumberTriviaEntity(text: 'test trivia', number: 1);

    // use async* instead of async for streams
    test(
        'should emit [LoadingState, DoneState] when data is gotten successfully',
        () async* {
      // arrange

      when(mockGetRandomNumberTriviaUseCase(params: any))
          .thenAnswer((_) async => const Right(tNumberTriviaEntity));
      // assert later
      final excepted = [
        EmptyNumberTriviaState(),
        LoadingNumberTriviaState(),
        const LoadedNumberTriviaState(numberTriviaEntity: tNumberTriviaEntity)
      ];
      // just like above we wait until our expectations are registered, only then we dispatch an event to the bloc
      expectLater(numberTriviaBloc.stream, emitsInOrder(excepted));
      // act
      numberTriviaBloc.add(GetRandomTriviaForRandomNumber());
    });

    test('should emit [LoadingState, ErrorState] when getting data fails',
        () async* {
      // arrange

      when(mockGetRandomNumberTriviaUseCase(params: any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final excepted = [
        EmptyNumberTriviaState(),
        LoadingNumberTriviaState(),
        const ErrorNumberTriviaState(message: SERVER_FAILURE_MESSAGE)
      ];
      // just like above we wait until our expectations are registered, only then we dispatch an event to the bloc
      expectLater(numberTriviaBloc.stream, emitsInOrder(excepted));
      // act
      numberTriviaBloc.add(GetRandomTriviaForRandomNumber());
    });

    test(
        'should emit [LoadingState, ErrorState] with proper message for the error when getting data fails',
        () async* {
      // arrange

      when(mockGetRandomNumberTriviaUseCase(params: any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final excepted = [
        EmptyNumberTriviaState(),
        LoadingNumberTriviaState(),
        const ErrorNumberTriviaState(message: CACHE_FAILURE_MESSAGE)
      ];

      // just like above we wait until our expectations are registered, only then we dispatch an event to the bloc
      expectLater(numberTriviaBloc.stream, emitsInOrder(excepted));
      // act
      numberTriviaBloc.add(GetRandomTriviaForRandomNumber());
    });
  });
}

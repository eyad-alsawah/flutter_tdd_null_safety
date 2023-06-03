import "package:dartz/dartz.dart";
import "package:mockito/mockito.dart";
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:tdd/core/usecases/usecase.dart";
import "package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart";

import "package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart";

import "package:tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart";

import "get_concrete_number_trivia_usecase_test.mocks.dart";

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main() {
  late GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  // mocking dependencies
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late NumberTriviaEntity tNumberTriviaEntity;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getRandomNumberTriviaUseCase =
        GetRandomNumberTriviaUseCase(mockNumberTriviaRepository);
    tNumberTriviaEntity =
        const NumberTriviaEntity(text: "test text", number: 1);
  });

  test('should get number trivia from the repository (usecase)', () async {
    // arrange
    //when our mock repository method gets called with the input we provided
    // methods in mocks are called stubs
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTriviaEntity));

    // act
    // dart has callable classes this way we don't have to use usecase.execute
    final result = await getRandomNumberTriviaUseCase(params: NoParams());

    // assert
    expect(result, equals(Right(tNumberTriviaEntity)));
    // verifying that the method in our mock repository was called with the right input
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    // verifying that no more method calls happen to our mock repository
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}

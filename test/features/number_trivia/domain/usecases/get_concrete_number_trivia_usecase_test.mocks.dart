// Mocks generated by Mockito 5.4.0 from annotations
// in tdd/test/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:tdd/core/errors/failures.dart' as _i5;
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart'
    as _i6;
import 'package:tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [NumberTriviaRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockNumberTriviaRepository extends _i1.Mock
    implements _i3.NumberTriviaRepository {
  @override
  _i4.Future<
      _i2.Either<_i5.Failure, _i6.NumberTriviaEntity>> getConcreteNumberTrivia(
          int? number) =>
      (super.noSuchMethod(
        Invocation.method(
          #getConcreteNumberTrivia,
          [number],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.NumberTriviaEntity>>.value(
                _FakeEither_0<_i5.Failure, _i6.NumberTriviaEntity>(
          this,
          Invocation.method(
            #getConcreteNumberTrivia,
            [number],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.NumberTriviaEntity>>.value(
                _FakeEither_0<_i5.Failure, _i6.NumberTriviaEntity>(
          this,
          Invocation.method(
            #getConcreteNumberTrivia,
            [number],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.NumberTriviaEntity>>);
  @override
  _i4.Future<
      _i2.Either<_i5.Failure,
          _i6.NumberTriviaEntity>> getRandomNumberTrivia() =>
      (super.noSuchMethod(
        Invocation.method(
          #getRandomNumberTrivia,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.NumberTriviaEntity>>.value(
                _FakeEither_0<_i5.Failure, _i6.NumberTriviaEntity>(
          this,
          Invocation.method(
            #getRandomNumberTrivia,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.NumberTriviaEntity>>.value(
                _FakeEither_0<_i5.Failure, _i6.NumberTriviaEntity>(
          this,
          Invocation.method(
            #getRandomNumberTrivia,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.NumberTriviaEntity>>);
}

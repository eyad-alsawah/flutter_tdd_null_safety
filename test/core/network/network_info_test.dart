import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:tdd/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InternetConnectionChecker>()])
void main() {
  late NetworkInfoImplementation networkInfoImplementation;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImplementation =
        NetworkInfoImplementation(mockInternetConnectionChecker);
  });

  group('checking connection status', () {
    test(
        'should forward the call to dataConnectionChecker.hasConnection, (checking that isConnected returns a Future<boo>)',
        () async {
      // arrange
      final tHasConnectionFuture = Future.value(true);
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      // act
      final result = networkInfoImplementation.isConnected;
      // assert
      expect(result, tHasConnectionFuture);
      verify(networkInfoImplementation.isConnected);
    });
  });
}

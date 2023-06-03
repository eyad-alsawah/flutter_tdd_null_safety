import 'dart:io';

String getFixture(String fixtureName) =>
    File('test/fixtures/$fixtureName').readAsStringSync();

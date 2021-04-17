import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

// import 'authentication_repository_test.mocks.dart';

//
// Awaiting fix in Mockito.
// https://github.com/dart-lang/mockito/issues/354
//

@GenerateMocks([FirebaseAuth])
void main() {
  test('Can instantiate', () {
    final auth = AuthenticationRepository();
    expect(auth, isA<AuthenticationRepository>());
  });
}

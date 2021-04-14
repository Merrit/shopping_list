// import 'package:flutter_test/flutter_test.dart';
// import 'package:shopping_list/domain/auth/value_objects.dart';
// import 'package:shopping_list/domain/core/failures.dart';

// void main() {
//   group('EmailAddress', () {
//     test('Can instantiate', () {
//       final emailAddress = EmailAddress('test@test.com');
//       expect(emailAddress, isA<EmailAddress>());
//     });

//     test('Invalid email contains failure', () {
//       final emailAddress = EmailAddress('test');
//       expect(emailAddress.value.fold((l) => null, (r) => null),
//           isA<ValueFailure<String>>());
//     });

//     test('Valid email contains email string', () {
//       final emailAddress = EmailAddress('iroh@BaSing.Se');
//       expect(emailAddress.value, isA<String>());
//       expect(emailAddress.value, equals('iroh@BaSing.Se'));
//     });
//   });
// }

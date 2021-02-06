import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

void main() {
  test('Can instantiate', () {
    FirestoreUser firestoreUser = FirestoreUser();
    expect(firestoreUser.runtimeType, FirestoreUser);
  });
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:shopping_list/app.dart';

// class MockFirestore extends Mock implements FirebaseFirestore {}

// class MockCollectionReference extends Mock implements CollectionReference {}

// class MockDocumentReference extends Mock implements DocumentReference {}

// class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

// @GenerateMocks([])
// void main() {
//   App? app;
//   var instance = MockFirestore();
//   var mockDocumentSnapshot = MockDocumentSnapshot();
//   var mockCollectionReference = MockCollectionReference();
//   var mockDocumentReference = MockDocumentReference();

//   setUp(() async {
//     app = App.instance;
//     await app?.init();
//   });

//   tearDown(() => app = null);

//   test('Should return data when the call to remote source is successful',
//       () async {
//     // arrange
//     when(instance.collection(any)).thenReturn(mockCollectionReference);
//     when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
//     when(mockDocumentReference.get())
//         .thenAnswer((_) async => mockDocumentSnapshot);
//     when(mockDocumentSnapshot.data()).thenReturn(responseMap);
//     //act

//     //assert
//   });
// }

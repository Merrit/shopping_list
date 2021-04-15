// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:logging/logging.dart';
// import 'package:shopping_list/app.dart';

// class AuthSubscription {
//   final Stream<User?> _authStream = FirebaseAuth.instance.authStateChanges();
//   final Logger _log = Logger('AuthSubscription');
//   late final StreamSubscription<User?> _streamSubscription;

//   void listen() {
//     _streamSubscription = _authStream.listen((User? user) {
//       if (user == null) {
//         _log.info('No user is signed in.');
//       } else {
//         _log.info('${user.email} is signed in.');
//         App.instance.user = user;
//       }
//     });
//   }

//   void cancel() => _streamSubscription.cancel();
// }

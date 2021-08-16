import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'failures.dart';
import 'models/models.dart';

export 'failures.dart';
export 'models/models.dart';

class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  /// Returns [User.empty] if there is no current user.
  User get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return (firebaseUser == null) ? User.empty : firebaseUser.toUser;
  }

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return User.empty;
      } else {
        return firebaseUser.toUser;
      }
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpFailure(e.code);
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw LogInWithGoogleFailure(
          exception: PlatformException(code: 'Sign in with Google aborted'),
        );
      }
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on PlatformException catch (e) {
      throw LogInWithGoogleFailure(exception: e);
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure(e);
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        if (_googleSignIn.currentUser != null) _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure(code: 'Logout failed');
    }
  }
}

/// Returns our version of `User` from the Firebase version.
extension on firebase_auth.User {
  User get toUser {
    return User(
      id: uid,
      email: email!,
      emailIsVerified: emailVerified,
    );
  }
}

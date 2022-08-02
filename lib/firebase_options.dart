// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD0LLnldNaXu5HGyTmzUeOsoACyHhAeKkA',
    appId: '1:117835173986:web:f06646318f2d293e2f013b',
    messagingSenderId: '117835173986',
    projectId: 'shopping-list-b2c41',
    authDomain: 'shopping-list-b2c41.firebaseapp.com',
    databaseURL: 'https://shopping-list-b2c41.firebaseio.com',
    storageBucket: 'shopping-list-b2c41.appspot.com',
    measurementId: 'G-LN4ZD88JMK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCu367MNp-5bp6vTWQcwhJ4hzhnZkWMpHU',
    appId: '1:117835173986:android:e34dc29a6f1350a82f013b',
    messagingSenderId: '117835173986',
    projectId: 'shopping-list-b2c41',
    databaseURL: 'https://shopping-list-b2c41.firebaseio.com',
    storageBucket: 'shopping-list-b2c41.appspot.com',
  );
}

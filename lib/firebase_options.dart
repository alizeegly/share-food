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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyCfHjoPmyDV7RSPRU8MsDCuVGyp42R6sek',
    appId: '1:934591545381:web:0b99ace1c3fa5a70333fcc',
    messagingSenderId: '934591545381',
    projectId: 'share-food-d3e9b',
    authDomain: 'share-food-d3e9b.firebaseapp.com',
    storageBucket: 'share-food-d3e9b.appspot.com',
    measurementId: 'G-62240S5M0Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZk8k16d1KESxK_ZTACGcXILq0tZmmpvc',
    appId: '1:934591545381:android:62540566e3b416f7333fcc',
    messagingSenderId: '934591545381',
    projectId: 'share-food-d3e9b',
    storageBucket: 'share-food-d3e9b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbPEyhd5O8XbMVe4dcJOx_ilzFaQ01I-c',
    appId: '1:934591545381:ios:6a888bb41f32fcc2333fcc',
    messagingSenderId: '934591545381',
    projectId: 'share-food-d3e9b',
    storageBucket: 'share-food-d3e9b.appspot.com',
    iosClientId: '934591545381-5s1lukbgnoeevvhd81u1r0tehs9b0qve.apps.googleusercontent.com',
    iosBundleId: 'com.example.sharefood',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbPEyhd5O8XbMVe4dcJOx_ilzFaQ01I-c',
    appId: '1:934591545381:ios:6a888bb41f32fcc2333fcc',
    messagingSenderId: '934591545381',
    projectId: 'share-food-d3e9b',
    storageBucket: 'share-food-d3e9b.appspot.com',
    iosClientId: '934591545381-5s1lukbgnoeevvhd81u1r0tehs9b0qve.apps.googleusercontent.com',
    iosBundleId: 'com.example.sharefood',
  );
}
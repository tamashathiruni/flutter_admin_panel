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
    apiKey: 'AIzaSyA16C37vkxof4Ibj_jLZw7j71YfXKwf5Qo',
    appId: '1:901564767504:web:25dd83f841f7b898ef5995',
    messagingSenderId: '901564767504',
    projectId: 'letfit-4a8ca',
    authDomain: 'letfit-4a8ca.firebaseapp.com',
    storageBucket: 'letfit-4a8ca.appspot.com',
    measurementId: 'G-043W334CPZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTTe0lnGybqpzUy6yBslkikrRFY8k_zJE',
    appId: '1:901564767504:android:ecd3ed194cdbf464ef5995',
    messagingSenderId: '901564767504',
    projectId: 'letfit-4a8ca',
    storageBucket: 'letfit-4a8ca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChYP0i5hfdpdmcLhUTyRZtXBxQeUshDmA',
    appId: '1:901564767504:ios:8d5d94372ca9b2c1ef5995',
    messagingSenderId: '901564767504',
    projectId: 'letfit-4a8ca',
    storageBucket: 'letfit-4a8ca.appspot.com',
    iosClientId: '901564767504-7i6blfd6gatq6p5p86f4qp0p9d1771j2.apps.googleusercontent.com',
    iosBundleId: 'com.example.admin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChYP0i5hfdpdmcLhUTyRZtXBxQeUshDmA',
    appId: '1:901564767504:ios:8d5d94372ca9b2c1ef5995',
    messagingSenderId: '901564767504',
    projectId: 'letfit-4a8ca',
    storageBucket: 'letfit-4a8ca.appspot.com',
    iosClientId: '901564767504-7i6blfd6gatq6p5p86f4qp0p9d1771j2.apps.googleusercontent.com',
    iosBundleId: 'com.example.admin',
  );
}

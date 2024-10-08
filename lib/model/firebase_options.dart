// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyChRXXPxAhUbKe7aTXcI0eUDGZypHH-f_c',
    appId: '1:1069618799031:web:323ffab6db43922f9bc832',
    messagingSenderId: '1069618799031',
    projectId: 'field-service-management-f2771',
    authDomain: 'field-service-management-f2771.firebaseapp.com',
    storageBucket: 'field-service-management-f2771.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBA9ndTBsyCXSigLif-osEy3cDLPwnHQXE',
    appId: '1:1069618799031:android:033855aa966264fa9bc832',
    messagingSenderId: '1069618799031',
    projectId: 'field-service-management-f2771',
    storageBucket: 'field-service-management-f2771.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBdFw9ioCOmPJmDb_b3IwoMmNXFXQEYXKA',
    appId: '1:1069618799031:ios:39ebdb56af1742699bc832',
    messagingSenderId: '1069618799031',
    projectId: 'field-service-management-f2771',
    storageBucket: 'field-service-management-f2771.appspot.com',
    iosBundleId: 'com.example.fieldServiceManagemenApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBdFw9ioCOmPJmDb_b3IwoMmNXFXQEYXKA',
    appId: '1:1069618799031:ios:39ebdb56af1742699bc832',
    messagingSenderId: '1069618799031',
    projectId: 'field-service-management-f2771',
    storageBucket: 'field-service-management-f2771.appspot.com',
    iosBundleId: 'com.example.fieldServiceManagemenApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyChRXXPxAhUbKe7aTXcI0eUDGZypHH-f_c',
    appId: '1:1069618799031:web:3c4d1c50ac33d4309bc832',
    messagingSenderId: '1069618799031',
    projectId: 'field-service-management-f2771',
    authDomain: 'field-service-management-f2771.firebaseapp.com',
    storageBucket: 'field-service-management-f2771.appspot.com',
  );
}

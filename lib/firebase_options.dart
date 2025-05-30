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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOd04FmN5jfwPuSF2taT9Yrx-euYsPPxc',
    appId: '1:44403949798:android:063b56935e527cfe48fb27',
    messagingSenderId: '44403949798',
    projectId: 'vivadoo-ddb5c',
    databaseURL: 'https://vivadoo-ddb5c.firebaseio.com',
    storageBucket: 'vivadoo-ddb5c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNGTs6K2LrGKI_9BU7-u-dFjGDaiAt7xo',
    appId: '1:44403949798:ios:cd1c793ec40b39e348fb27',
    messagingSenderId: '44403949798',
    projectId: 'vivadoo-ddb5c',
    databaseURL: 'https://vivadoo-ddb5c.firebaseio.com',
    storageBucket: 'vivadoo-ddb5c.firebasestorage.app',
    androidClientId: '44403949798-1b5n8gv242t4tcks1id4r119opkkgtjh.apps.googleusercontent.com',
    iosClientId: '44403949798-p6dlkf62je8fd9c5t1tnmi9rn9sop8fq.apps.googleusercontent.com',
    iosBundleId: 'com.Thales.Vivadoo',
  );

}
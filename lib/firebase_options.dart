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
    apiKey: 'AIzaSyBesfpK2yP1eJACPy3LPbP3z4ynbLSWT4Y',
    appId: '1:1067148220399:web:162b456ee35c4721e3481a',
    messagingSenderId: '1067148220399',
    projectId: 'dexter-dev313',
    authDomain: 'dexter-dev313.firebaseapp.com',
    databaseURL: 'https://dexter-dev313-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'dexter-dev313.appspot.com',
    measurementId: 'G-4FXPHWD5PK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYyprlYKVgsb4oDX5Uia300MBakFHmxdQ',
    appId: '1:1067148220399:android:4bdbb5147b809738e3481a',
    messagingSenderId: '1067148220399',
    projectId: 'dexter-dev313',
    databaseURL: 'https://dexter-dev313-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'dexter-dev313.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgBwq_Q3-VQeSEw7CJ1HH1drxijCeH1b8',
    appId: '1:1067148220399:ios:1103fbe667be6e22e3481a',
    messagingSenderId: '1067148220399',
    projectId: 'dexter-dev313',
    databaseURL: 'https://dexter-dev313-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'dexter-dev313.appspot.com',
    iosBundleId: 'com.example.inventoryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAgBwq_Q3-VQeSEw7CJ1HH1drxijCeH1b8',
    appId: '1:1067148220399:ios:1103fbe667be6e22e3481a',
    messagingSenderId: '1067148220399',
    projectId: 'dexter-dev313',
    databaseURL: 'https://dexter-dev313-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'dexter-dev313.appspot.com',
    iosBundleId: 'com.example.inventoryApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBesfpK2yP1eJACPy3LPbP3z4ynbLSWT4Y',
    appId: '1:1067148220399:web:aa9da21441a979eee3481a',
    messagingSenderId: '1067148220399',
    projectId: 'dexter-dev313',
    authDomain: 'dexter-dev313.firebaseapp.com',
    databaseURL: 'https://dexter-dev313-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'dexter-dev313.appspot.com',
    measurementId: 'G-LCSTLP76FH',
  );
}

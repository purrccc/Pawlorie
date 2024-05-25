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
    apiKey: 'AIzaSyB3WTJn5clJulp-EG3MSfjOhTiFJlGc3Qc',
    appId: '1:348362999929:web:7aa01a984aa8a18293aca8',
    messagingSenderId: '348362999929',
    projectId: 'pawlorie',
    authDomain: 'pawlorie.firebaseapp.com',
    storageBucket: 'pawlorie.appspot.com',
    measurementId: 'G-ZQCW5CCPJ4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyArRoskgvO2gjw-OTdwSB0UA9W4Nf_kS-0',
    appId: '1:348362999929:android:1341cd4a01680eea93aca8',
    messagingSenderId: '348362999929',
    projectId: 'pawlorie',
    storageBucket: 'pawlorie.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSAW4GbNMDnJcJzmFdILbL6Mogqe7Hk34',
    appId: '1:348362999929:ios:400e157986e6b66c93aca8',
    messagingSenderId: '348362999929',
    projectId: 'pawlorie',
    storageBucket: 'pawlorie.appspot.com',
    iosBundleId: 'com.example.pawlorie',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCSAW4GbNMDnJcJzmFdILbL6Mogqe7Hk34',
    appId: '1:348362999929:ios:400e157986e6b66c93aca8',
    messagingSenderId: '348362999929',
    projectId: 'pawlorie',
    storageBucket: 'pawlorie.appspot.com',
    iosBundleId: 'com.example.pawlorie',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB3WTJn5clJulp-EG3MSfjOhTiFJlGc3Qc',
    appId: '1:348362999929:web:61498ec70be2056693aca8',
    messagingSenderId: '348362999929',
    projectId: 'pawlorie',
    authDomain: 'pawlorie.firebaseapp.com',
    storageBucket: 'pawlorie.appspot.com',
    measurementId: 'G-WVYFL4YNRQ',
  );

}
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBIIDQUfqFzpsq6jslc08BwoL38KK2go1o',
    authDomain: 'dartcampus-25913.firebaseapp.com',
    projectId: 'dartcampus-25913',
    storageBucket: 'dartcampus-25913.firebasestorage.app',
    messagingSenderId: '734480265364',
    appId: '1:734480265364:web:be23e65d698b167304c481',
    measurementId: 'G-6SQYKPVW24',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIIDQUfqFzpsq6jslc08BwoL38KK2go1o',
    authDomain: 'dartcampus-25913.firebaseapp.com',
    projectId: 'dartcampus-25913',
    storageBucket: 'dartcampus-25913.firebasestorage.app',
    messagingSenderId: '734480265364',
    appId: '1:734480265364:android:be23e65d698b167304c481', 
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBIIDQUfqFzpsq6jslc08BwoL38KK2go1o',
    authDomain: 'dartcampus-25913.firebaseapp.com',
    projectId: 'dartcampus-25913',
    storageBucket: 'dartcampus-25913.firebasestorage.app',
    messagingSenderId: '734480265364',
    appId: '1:734480265364:ios:be23e65d698b167304c481',
    iosBundleId: 'com.example.dartcodeCampus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBIIDQUfqFzpsq6jslc08BwoL38KK2go1o',
    authDomain: 'dartcampus-25913.firebaseapp.com',
    projectId: 'dartcampus-25913',
    storageBucket: 'dartcampus-25913.firebasestorage.app',
    messagingSenderId: '734480265364',
    appId: '1:734480265364:ios:be23e65d698b167304c481',
    iosBundleId: 'com.example.dartcodeCampus',
  );
}

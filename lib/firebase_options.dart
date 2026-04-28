// Generated Firebase options for the Focus app.
// Source: mrblack/frontend/firebase-applet-config.json
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAGfRBZU5__M3xwrBeOs5JPummsjDR_w30',
    authDomain: 'focus-mobile-app-b4015.firebaseapp.com',
    projectId: 'focus-mobile-app-b4015',
    storageBucket: 'focus-mobile-app-b4015.firebasestorage.app',
    messagingSenderId: '788029500804',
    appId: '1:788029500804:web:3e492666c3e8dd86ea81d1',
    measurementId: 'G-XXB1Q8FSZE',
  );

  // Android: add google-services.json and these options when building for device
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGfRBZU5__M3xwrBeOs5JPummsjDR_w30',
    appId: '1:788029500804:android:focusandroid',
    messagingSenderId: '788029500804',
    projectId: 'focus-mobile-app-b4015',
    storageBucket: 'focus-mobile-app-b4015.firebasestorage.app',
  );

  // iOS: add GoogleService-Info.plist when building for device
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGfRBZU5__M3xwrBeOs5JPummsjDR_w30',
    appId: '1:788029500804:ios:focusios',
    messagingSenderId: '788029500804',
    projectId: 'focus-mobile-app-b4015',
    storageBucket: 'focus-mobile-app-b4015.firebasestorage.app',
    iosBundleId: 'com.focus.socialclub',
  );
}

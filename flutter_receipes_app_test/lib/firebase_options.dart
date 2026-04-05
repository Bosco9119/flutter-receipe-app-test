// File generated manually from `android/app/google-services.json`.
// For iOS/Web/macOS, run: dart run flutterfire configure
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for this Flutter app.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web: run `dart run flutterfire configure` and add web to FirebaseOptions.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'Add `ios/Runner/GoogleService-Info.plist` then run flutterfire configure.',
        );
      default:
        throw UnsupportedError(
          'FirebaseOptions are only defined for Android in this project.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHCZ4DF9ho4gYuSnheatrvEJE5h3HRBjc',
    appId: '1:683700394647:android:0b92813578c2ff412aa7d2',
    messagingSenderId: '683700394647',
    projectId: 'flutter-recipe-app-test-8f683',
    storageBucket: 'flutter-recipe-app-test-8f683.firebasestorage.app',
  );
}

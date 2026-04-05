import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/auth/google_sign_in_cancelled_exception.dart';
import 'firebase_identity_data_source.dart';

class FirebaseIdentityDataSourceImpl implements FirebaseIdentityDataSource {
  FirebaseIdentityDataSourceImpl({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  bool _googleInitialized = false;

  /// Web client ID from `android/app/google-services.json` → `oauth_client` with `client_type: 3`.
  /// Required so the ID token is minted for Firebase Auth on Android.
  static const String _serverClientId =
      '683700394647-o5hca8fvh2v6bq9501vvphtokpaul5gk.apps.googleusercontent.com';

  Future<void> _ensureGoogleSignInReady() async {
    if (_googleInitialized) {
      return;
    }
    await GoogleSignIn.instance.initialize(serverClientId: _serverClientId);
    _googleInitialized = true;
  }

  @override
  Future<FirebaseIdentitySnapshot> signInWithGoogle() async {
    await _ensureGoogleSignInReady();

    try {
      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email', 'profile'],
      );
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw StateError('Missing Google ID token');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;
      if (user == null) {
        throw StateError('Firebase user missing after Google sign-in');
      }

      final email = user.email ?? account.email;
      final displayName = user.displayName ?? account.displayName;
      final photoUrl = user.photoURL ?? account.photoUrl;
      final username = (displayName?.trim().isNotEmpty ?? false)
          ? displayName!.trim()
          : (email.trim().isNotEmpty ? email.trim() : user.uid);

      return FirebaseIdentitySnapshot(
        remoteUserId: user.uid,
        username: username,
        email: email.isNotEmpty ? email : null,
        displayName: displayName,
        photoUrl: photoUrl,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw GoogleSignInCancelledException();
      }
      debugPrint('GoogleSignInException: ${e.code} ${e.description}');
      rethrow;
    } on FirebaseAuthException catch (e, st) {
      debugPrint(
        'FirebaseAuthException: ${e.code} ${e.message}\n$st',
      );
      rethrow;
    } catch (e, st) {
      debugPrint('signInWithGoogle failed: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> signOutGoogleAndFirebase() async {
    await _ensureGoogleSignInReady();
    await Future.wait<void>([_auth.signOut(), GoogleSignIn.instance.signOut()]);
  }
}

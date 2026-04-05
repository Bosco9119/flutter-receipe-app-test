/// Remote identity: Google Sign-In + Firebase Auth.
abstract class FirebaseIdentityDataSource {
  /// Interactive Google sign-in, then Firebase credential exchange.
  Future<FirebaseIdentitySnapshot> signInWithGoogle();

  /// Signs out Firebase and clears Google session when applicable.
  Future<void> signOutGoogleAndFirebase();
}

/// Normalized user info after a successful Google + Firebase sign-in.
class FirebaseIdentitySnapshot {
  const FirebaseIdentitySnapshot({
    required this.remoteUserId,
    required this.username,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  final String remoteUserId;
  final String username;
  final String? email;
  final String? displayName;
  final String? photoUrl;
}

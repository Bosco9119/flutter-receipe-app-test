import 'package:flutter/foundation.dart';

/// Local demo account vs Firebase Google sign-in.
enum AuthProviderKind {
  demo,
  google,
}

@immutable
class AuthSessionEntity {
  const AuthSessionEntity({
    required this.username,
    required this.issuedAt,
    this.provider = AuthProviderKind.demo,
    this.email,
    this.displayName,
    this.photoUrl,
    /// Firebase Auth UID; use as Firestore path key when cloud sync is added.
    this.remoteUserId,
  });

  /// Display handle (demo user name, or Google email / name fallback).
  final String username;
  final DateTime issuedAt;
  final AuthProviderKind provider;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? remoteUserId;
}

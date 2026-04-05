import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/auth/google_sign_in_cancelled_exception.dart';
import '../../core/constants/storage_keys.dart';
import '../../core/security/crypto_service.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_identity_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required SharedPreferences preferences,
    required CryptoService crypto,
    required FirebaseIdentityDataSource firebaseIdentity,
  }) : _preferences = preferences,
       _crypto = crypto,
       _firebaseIdentity = firebaseIdentity,
       _demoPasswordHash = crypto.hashCredential('demo');

  final SharedPreferences _preferences;
  final CryptoService _crypto;
  final FirebaseIdentityDataSource _firebaseIdentity;
  final String _demoPasswordHash;

  final _controller = StreamController<AuthSessionEntity?>.broadcast();

  static AuthProviderKind _parseProvider(String? raw) {
    if (raw == 'google') {
      return AuthProviderKind.google;
    }
    return AuthProviderKind.demo;
  }

  AuthSessionEntity? _readSession() {
    final raw = _preferences.getString(StorageKeys.authSession);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final jsonText = _crypto.decryptPayload(raw);
      final map = jsonDecode(jsonText) as Map<String, dynamic>;
      return AuthSessionEntity(
        username: map['username'] as String,
        issuedAt: DateTime.parse(map['issuedAt'] as String),
        provider: _parseProvider(map['provider'] as String?),
        email: map['email'] as String?,
        displayName: map['displayName'] as String?,
        photoUrl: map['photoUrl'] as String?,
        remoteUserId: map['remoteUserId'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _sessionToMap(AuthSessionEntity session) {
    return {
      'username': session.username,
      'issuedAt': session.issuedAt.toIso8601String(),
      'provider': session.provider.name,
      'email': session.email,
      'displayName': session.displayName,
      'photoUrl': session.photoUrl,
      'remoteUserId': session.remoteUserId,
    };
  }

  Future<void> _persistSession(AuthSessionEntity session) async {
    final payload = jsonEncode(_sessionToMap(session));
    final encrypted = _crypto.encryptPayload(payload);
    await _preferences.setString(StorageKeys.authSession, encrypted);
  }

  void _emit(AuthSessionEntity? session) {
    if (!_controller.isClosed) {
      _controller.add(session);
    }
  }

  @override
  AuthSessionEntity? readPersistedSession() => _readSession();

  @override
  Stream<AuthSessionEntity?> watchSession() {
    return Stream<AuthSessionEntity?>.multi((controller) {
      controller.add(_readSession());
      final sub = _controller.stream.listen(controller.add);
      controller.onCancel = () => sub.cancel();
    });
  }

  @override
  Future<AuthSessionEntity> login({
    required String username,
    required String password,
  }) async {
    final normalizedUser = username.trim();
    if (normalizedUser.isEmpty) {
      throw ArgumentError('Username required');
    }

    final isDemo =
        normalizedUser == 'demo' &&
        _crypto.verifyHash(password, _demoPasswordHash);
    if (!isDemo) {
      throw StateError('Invalid credentials (try demo / demo)');
    }

    final session = AuthSessionEntity(
      username: normalizedUser,
      issuedAt: DateTime.now().toUtc(),
      provider: AuthProviderKind.demo,
    );
    await _persistSession(session);
    _emit(session);
    return session;
  }

  @override
  Future<AuthSessionEntity> signInWithGoogle() async {
    try {
      final snap = await _firebaseIdentity.signInWithGoogle();
      final session = AuthSessionEntity(
        username: snap.username,
        issuedAt: DateTime.now().toUtc(),
        provider: AuthProviderKind.google,
        email: snap.email,
        displayName: snap.displayName,
        photoUrl: snap.photoUrl,
        remoteUserId: snap.remoteUserId,
      );
      await _persistSession(session);
      _emit(session);
      return session;
    } on GoogleSignInCancelledException {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    final current = _readSession();
    if (current?.provider == AuthProviderKind.google) {
      try {
        await _firebaseIdentity.signOutGoogleAndFirebase();
      } catch (_) {
        // Still clear local session if remote sign-out fails.
      }
    }
    await _preferences.remove(StorageKeys.authSession);
    _emit(null);
  }
}

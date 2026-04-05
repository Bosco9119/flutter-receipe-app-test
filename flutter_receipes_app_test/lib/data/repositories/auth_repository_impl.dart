import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/security/crypto_service.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required SharedPreferences preferences,
    required CryptoService crypto,
  })  : _preferences = preferences,
        _crypto = crypto,
        _demoPasswordHash = crypto.hashCredential('demo');

  final SharedPreferences _preferences;
  final CryptoService _crypto;
  final String _demoPasswordHash;

  final _controller = StreamController<AuthSessionEntity?>.broadcast();

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
      );
    } catch (_) {
      return null;
    }
  }

  void _emit(AuthSessionEntity? session) {
    if (!_controller.isClosed) {
      _controller.add(session);
    }
  }

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

    final isDemo = normalizedUser == 'demo' &&
        _crypto.verifyHash(password, _demoPasswordHash);
    if (!isDemo) {
      throw StateError('Invalid credentials (try demo / demo)');
    }

    final session = AuthSessionEntity(
      username: normalizedUser,
      issuedAt: DateTime.now().toUtc(),
    );
    final payload = jsonEncode({
      'username': session.username,
      'issuedAt': session.issuedAt.toIso8601String(),
    });
    final encrypted = _crypto.encryptPayload(payload);
    await _preferences.setString(StorageKeys.authSession, encrypted);
    _emit(session);
    return session;
  }

  @override
  Future<void> logout() async {
    await _preferences.remove(StorageKeys.authSession);
    _emit(null);
  }
}

import '../entities/auth_session_entity.dart';

abstract class AuthRepository {
  Stream<AuthSessionEntity?> watchSession();

  /// Encrypted session from storage (no stream); used to scope local data before UI builds.
  AuthSessionEntity? readPersistedSession();

  Future<AuthSessionEntity> login({
    required String username,
    required String password,
  });

  /// Firebase Auth + Google identity; persists session like [login].
  Future<AuthSessionEntity> signInWithGoogle();

  Future<void> logout();
}

import 'auth_session_entity.dart';

/// Namespaces local recipe JSON in Hive (and will match Firestore `users/{id}/...`).
///
/// Google: raw Firebase Auth UID. Demo / other local sessions: `local_<username>`.
String recipeOwnerStorageId(AuthSessionEntity session) {
  if (session.provider == AuthProviderKind.google) {
    final uid = session.remoteUserId?.trim();
    if (uid != null && uid.isNotEmpty) {
      return uid;
    }
  }
  final u = session.username.trim().toLowerCase();
  if (u.isEmpty) {
    return 'local_anonymous';
  }
  return 'local_$u';
}

/// Firestore paths use the Firebase Auth UID; demo/local accounts cannot use cloud backup with default security rules.
bool sessionEligibleForCloudSync(AuthSessionEntity session) {
  if (session.provider != AuthProviderKind.google) {
    return false;
  }
  final uid = session.remoteUserId?.trim();
  return uid != null && uid.isNotEmpty;
}


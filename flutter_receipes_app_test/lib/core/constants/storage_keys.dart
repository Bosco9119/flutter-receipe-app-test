/// Central keys for persisted storage (Hive box keys, SharedPreferences keys).
abstract final class StorageKeys {
  static const String recipesJson = 'recipes_json_v1';
  static const String themeMode = 'settings_theme_mode';
  static const String localeTag = 'settings_locale_tag';
  static const String authSession = 'auth_session_cipher_v1';
}

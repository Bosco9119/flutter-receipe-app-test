// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Buku Resep';

  @override
  String get architecturePreview =>
      'Lapisan arsitektur sudah terhubung. Alur resep akan ditambahkan di sini.';

  @override
  String get themeSection => 'Tampilan';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get language => 'Bahasa';

  @override
  String get english => 'Inggris';

  @override
  String get indonesian => 'Indonesia';

  @override
  String get recipes => 'Resep';

  @override
  String get login => 'Masuk';

  @override
  String get logout => 'Keluar';

  @override
  String get settings => 'Pengaturan';

  @override
  String get home => 'Beranda';

  @override
  String get streamDemoTitle => 'Jumlah resep langsung (stream reaktif)';

  @override
  String recipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resep',
      one: '1 resep',
      zero: 'Tidak ada resep',
    );
    return '$_temp0';
  }

  @override
  String get myRecipes => 'Resep Saya';

  @override
  String get myRecipesSubtitle => 'Temukan dan kelola resep favorit Anda';

  @override
  String get searchRecipesHint => 'Cari resep…';

  @override
  String get filterRecipes => 'Saring menurut jenis';

  @override
  String get allTypes => 'Semua Jenis';

  @override
  String get newRecipe => 'Resep Baru';

  @override
  String recipesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resep ditemukan',
      one: '1 resep ditemukan',
      zero: 'Tidak ada resep',
    );
    return '$_temp0';
  }

  @override
  String prepTimeMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes menit',
      one: '1 menit',
    );
    return '$_temp0';
  }

  @override
  String servingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porsi',
      one: '1 porsi',
    );
    return '$_temp0';
  }

  @override
  String get createRecipeComingSoon =>
      'Layar buat resep akan ditambahkan di sini — bahan, langkah, dan pemilih foto terhubung ke lapisan MVVM berikutnya.';

  @override
  String get noRecipesMatch =>
      'Tidak ada resep yang cocok dengan pencarian atau saringan Anda.';
}

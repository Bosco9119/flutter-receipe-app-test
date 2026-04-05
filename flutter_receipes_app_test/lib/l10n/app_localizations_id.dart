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
  String get noRecipesMatch =>
      'Tidak ada resep yang cocok dengan pencarian atau saringan Anda.';

  @override
  String get backToRecipes => 'Kembali ke resep';

  @override
  String get createRecipeTitle => 'Buat resep baru';

  @override
  String get recipeTitleLabel => 'Judul resep *';

  @override
  String get recipeTypeLabel => 'Jenis resep *';

  @override
  String get selectRecipeTypeHint => 'Pilih jenis';

  @override
  String get prepTimeLabel => 'Waktu persiapan *';

  @override
  String get prepTimeHint => 'mis. 30 atau 30 menit';

  @override
  String get servingsLabel => 'Porsi *';

  @override
  String get servingsHint => 'mis. 4';

  @override
  String get prepTimeInvalid => 'Masukkan angka waktu (mis. 15 atau 20 menit).';

  @override
  String get servingsInvalid => 'Masukkan bilangan bulat ≥ 1.';

  @override
  String get fieldRequired => 'Wajib diisi';

  @override
  String get recipePhotoLabel => 'Foto resep';

  @override
  String get recipePhotoHelper =>
      'Opsional. Pilih dari galeri atau kamera di ponsel. Jika dilewati, gambar default dipakai.';

  @override
  String get recipePhotoWebNote =>
      'Pemilih foto tersedia di aplikasi mobile/desktop. Di web, gambar default dipakai.';

  @override
  String get pickFromGallery => 'Galeri';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get clearPhoto => 'Hapus foto';

  @override
  String get ingredientsSectionLabel => 'Bahan *';

  @override
  String get addIngredient => '+ Tambah bahan';

  @override
  String ingredientHint(int n) {
    return 'Bahan $n';
  }

  @override
  String get stepsSectionLabel => 'Langkah *';

  @override
  String get addStep => '+ Tambah langkah';

  @override
  String stepHint(int n) {
    return 'Langkah $n';
  }

  @override
  String get cancel => 'Batal';

  @override
  String get dialogConfirm => 'Konfirmasi';

  @override
  String get createRecipeSubmit => 'Buat resep';

  @override
  String get createRecipeFailed => 'Gagal menyimpan resep.';

  @override
  String get recipeTypeRequired => 'Pilih jenis resep.';

  @override
  String get ingredientsRequired => 'Tambah minimal satu bahan.';

  @override
  String get stepsRequired => 'Tambah minimal satu langkah.';

  @override
  String get recipeNotFound => 'Resep tidak ditemukan';

  @override
  String get recipeNotFoundMessage =>
      'Resep ini mungkin sudah dihapus atau tidak tersedia.';

  @override
  String get editRecipe => 'Ubah';

  @override
  String get deleteRecipe => 'Hapus';

  @override
  String get deleteRecipeTitle => 'Hapus resep?';

  @override
  String get deleteRecipeMessage =>
      'Tindakan ini tidak dapat dibatalkan. Resep akan dihapus dari perangkat Anda.';

  @override
  String get deleteRecipeConfirm => 'Hapus';

  @override
  String get deleteRecipeFailed => 'Gagal menghapus resep.';

  @override
  String get ingredientsHeading => 'Bahan';

  @override
  String get instructionsHeading => 'Instruksi';

  @override
  String get recipeUpdated => 'Resep diperbarui.';

  @override
  String get editRecipeTitle => 'Ubah resep';

  @override
  String get saveRecipeChanges => 'Simpan perubahan';
}

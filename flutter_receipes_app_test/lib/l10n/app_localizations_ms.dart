// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Buku Resipi';

  @override
  String get architecturePreview =>
      'Lapisan seni bina telah disambungkan. Aliran resipi akan disambungkan di sini.';

  @override
  String get themeSection => 'Penampilan';

  @override
  String get themeLight => 'Cerah';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get language => 'Bahasa';

  @override
  String get english => 'Bahasa Inggeris';

  @override
  String get malay => 'Bahasa Melayu';

  @override
  String get chinese => 'Cina (Ringkas)';

  @override
  String get recipes => 'Resipi';

  @override
  String get login => 'Log masuk';

  @override
  String get loginUsernameLabel => 'Nama pengguna';

  @override
  String get loginPasswordLabel => 'Kata laluan';

  @override
  String get loginDemoHint => 'Petunjuk: demo / demo';

  @override
  String get loginOrDivider => 'atau';

  @override
  String get continueWithGoogle => 'Teruskan dengan Google';

  @override
  String get googleSignInFailed =>
      'Log masuk Google gagal. Semak konfigurasi Firebase dan cuba lagi.';

  @override
  String get logout => 'Log keluar';

  @override
  String get settings => 'Tetapan';

  @override
  String get settingsDrawerLocalOnly =>
      'Log masuk tempatan (tiada Gmail pada akaun ini)';

  @override
  String get home => 'Laman utama';

  @override
  String get streamDemoTitle => 'Kiraan resipi langsung (strim reaktif)';

  @override
  String recipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resipi',
      one: '1 resipi',
      zero: 'Tiada resipi',
    );
    return '$_temp0';
  }

  @override
  String get myRecipes => 'Resipi Saya';

  @override
  String get myRecipesSubtitle => 'Cari dan urus resipi kegemaran anda';

  @override
  String get searchRecipesHint => 'Cari resipi…';

  @override
  String get sortRecipesTooltip => 'Isih resipi';

  @override
  String get sortSheetTitle => 'Isih mengikut';

  @override
  String get sortTitleAZ => 'Tajuk A–Z';

  @override
  String get sortTitleZA => 'Tajuk Z–A';

  @override
  String get sortPrepShortFirst => 'Masa penyediaan (paling pendek dahulu)';

  @override
  String get sortPrepLongFirst => 'Masa penyediaan (paling panjang dahulu)';

  @override
  String get allTypes => 'Semua jenis';

  @override
  String get newRecipe => 'Resipi baharu';

  @override
  String recipesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resipi dijumpai',
      one: '1 resipi dijumpai',
      zero: 'Tiada resipi dijumpai',
    );
    return '$_temp0';
  }

  @override
  String prepTimeMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minit',
      one: '1 minit',
    );
    return '$_temp0';
  }

  @override
  String servingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hidangan',
      one: '1 hidangan',
    );
    return '$_temp0';
  }

  @override
  String get noRecipesMatch =>
      'Tiada resipi yang sepadan dengan carian atau tapisan anda.';

  @override
  String get backToRecipes => 'Kembali ke resipi';

  @override
  String get createRecipeTitle => 'Cipta resipi baharu';

  @override
  String get recipeTitleLabel => 'Tajuk resipi *';

  @override
  String get recipeDescriptionLabel => 'Penerangan';

  @override
  String get recipeDescriptionHint =>
      'Ringkasan ringkas (pilihan), seperti dalam recipes.json.';

  @override
  String get recipeTypeLabel => 'Jenis resipi *';

  @override
  String get selectRecipeTypeHint => 'Pilih jenis';

  @override
  String get prepTimeLabel => 'Masa penyediaan *';

  @override
  String get prepTimeHint => 'cth. 30 atau 30 minit';

  @override
  String get servingsLabel => 'Hidangan *';

  @override
  String get servingsHint => 'cth. 4';

  @override
  String get prepTimeInvalid =>
      'Masukkan masa penyediaan dengan nombor (cth. 15 atau 20 min).';

  @override
  String get servingsInvalid => 'Masukkan nombor bulat ≥ 1.';

  @override
  String get fieldRequired => 'Wajib';

  @override
  String get recipePhotoLabel => 'Foto resipi';

  @override
  String get recipePhotoHelper =>
      'Pilihan. Pilih dari galeri atau kamera pada telefon. Jika dilangkau, imej lalai digunakan.';

  @override
  String get recipePhotoWebNote =>
      'Pemilih foto tersedia pada aplikasi mudah alih/desktop. Di web, imej lalai digunakan melainkan dibina untuk platform dengan galeri/kamera.';

  @override
  String get pickFromGallery => 'Galeri';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get clearPhoto => 'Buang foto';

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
  String get dialogConfirm => 'Sahkan';

  @override
  String get createRecipeSubmit => 'Cipta resipi';

  @override
  String get createRecipeFailed => 'Tidak dapat menyimpan resipi.';

  @override
  String get recipeTypeRequired => 'Pilih jenis resipi.';

  @override
  String get ingredientsRequired => 'Tambah sekurang-kurangnya satu bahan.';

  @override
  String get stepsRequired => 'Tambah sekurang-kurangnya satu langkah.';

  @override
  String get recipeNotFound => 'Resipi tidak dijumpai';

  @override
  String get recipeNotFoundMessage =>
      'Resipi ini mungkin telah dipadam atau tidak lagi tersedia.';

  @override
  String get editRecipe => 'Sunting';

  @override
  String get deleteRecipe => 'Padam';

  @override
  String get deleteRecipeTitle => 'Padam resipi?';

  @override
  String get deleteRecipeMessage =>
      'Tindakan ini tidak boleh dibuat asal. Resipi akan dialih keluar daripada peranti anda.';

  @override
  String get deleteRecipeConfirm => 'Padam';

  @override
  String get deleteRecipeFailed => 'Tidak dapat memadam resipi.';

  @override
  String get ingredientsHeading => 'Bahan';

  @override
  String get instructionsHeading => 'Cara penyediaan';

  @override
  String get recipeUpdated => 'Resipi dikemas kini.';

  @override
  String get editRecipeTitle => 'Sunting resipi';

  @override
  String get saveRecipeChanges => 'Simpan perubahan';

  @override
  String get settingsCloudBackupSection => 'Sandaran awan';

  @override
  String get settingsSyncToCloud => 'Segerak ke awan';

  @override
  String get settingsRestoreFromCloud => 'Pulihkan dari awan';

  @override
  String get cloudSyncRequiresGoogle =>
      'Log masuk dengan Google untuk sandaran awan.';

  @override
  String get cloudSyncDialogTitle => 'Segerak ke awan';

  @override
  String get cloudSyncDialogSubtitle =>
      'Awan akan sepadan dengan peranti: muat naik, kemas kini, dan buang resipi awan yang tidak ada pada peranti.';

  @override
  String get cloudRestoreDialogTitle => 'Pulihkan dari awan';

  @override
  String get cloudRestoreDialogSubtitle =>
      'Peranti akan sepadan dengan awan: muat turun, kemas kini, dan buang resipi tempatan yang tidak ada di awan.';

  @override
  String get cloudDiffLoading => 'Membandingkan peranti dan awan…';

  @override
  String get cloudDiffOnlyOnDeviceSync =>
      'Hanya pada peranti — akan dimuat naik ke awan';

  @override
  String get cloudDiffOnlyInCloudSync =>
      'Hanya di awan — akan dibuang dari awan';

  @override
  String get cloudDiffOnBothSync =>
      'Kedua-duanya — salinan awan diganti dari peranti';

  @override
  String get cloudDiffOnlyOnDeviceRestore =>
      'Hanya pada peranti — akan dibuang dari peranti';

  @override
  String get cloudDiffOnlyInCloudRestore =>
      'Hanya di awan — akan dimuat turun ke peranti';

  @override
  String get cloudDiffOnBothRestore =>
      'Kedua-duanya — salinan peranti diganti dari awan';

  @override
  String get cloudSyncRunConfirm => 'Gunakan segerak';

  @override
  String get cloudRestoreRunConfirm => 'Gunakan pemulihan';

  @override
  String get cloudBackupCancel => 'Batal';

  @override
  String get cloudBackupDone => 'Sandaran awan dikemas kini.';

  @override
  String get cloudRestoreDone => 'Dipulihkan dari awan.';

  @override
  String get cloudNoRecipesInSection => 'Tiada';

  @override
  String get settingsDiscoverSection => 'Terokai';

  @override
  String get drawerDiscoverRecipes => 'Cari resipi rawak';

  @override
  String get discoverRecipesTitle => 'Cari resipi';

  @override
  String get discoverRecipesSubtitle => 'Hidangan rawak dari TheMealDB';

  @override
  String get discoverLoadTenButton => 'Muat 10 resipi rawak';

  @override
  String discoverFetchProgress(int done, int total) {
    return '$done daripada $total permintaan selesai';
  }

  @override
  String get discoverEmptyHint =>
      'Ketik butang di atas untuk memuat sepuluh hidangan rawak dari TheMealDB (satu permintaan demi satu).';

  @override
  String get discoverErrorAllFailed =>
      'Semua permintaan gagal. Semak sambungan dan cuba lagi.';

  @override
  String get discoverErrorNoRecipes => 'Tiada resipi dikembalikan. Cuba lagi.';

  @override
  String discoverSomeRequestsFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count permintaan gagal',
      one: '1 permintaan gagal',
    );
    return '$_temp0';
  }

  @override
  String get discoverPrepOnImport =>
      'Tetapkan masa penyediaan semasa menyimpan';

  @override
  String get discoverServingsOnImport => 'Tetapkan hidangan semasa menyimpan';

  @override
  String get discoverUnknownCategory => 'TheMealDB';

  @override
  String get discoverBackToList => 'Kembali ke carian';

  @override
  String get discoverDetailImportCta => 'Tambah ke resipi saya';

  @override
  String get importRecipeTitle => 'Tambah ke resipi saya';

  @override
  String get importRecipeSavedMessage => 'Resipi ditambah ke koleksi anda.';
}

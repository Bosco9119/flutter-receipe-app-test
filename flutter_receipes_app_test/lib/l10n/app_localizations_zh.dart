// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'MyFoodJourney';

  @override
  String get architecturePreview => '架构层已连接，食谱流程将在此处接入。';

  @override
  String get themeSection => '外观';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get language => '语言';

  @override
  String get english => '英语';

  @override
  String get malay => '马来语';

  @override
  String get chinese => '简体中文';

  @override
  String get recipes => '食谱';

  @override
  String get login => '登录';

  @override
  String get loginUsernameLabel => '用户名';

  @override
  String get loginPasswordLabel => '密码';

  @override
  String get loginDemoHint => '提示：demo / demo';

  @override
  String get loginOrDivider => '或';

  @override
  String get continueWithGoogle => '使用 Google 继续';

  @override
  String get googleSignInFailed => 'Google 登录失败。请检查 Firebase 配置后重试。';

  @override
  String get logout => '退出登录';

  @override
  String get settings => '设置';

  @override
  String get settingsDrawerLocalOnly => '本地登录（此账号未绑定 Gmail）';

  @override
  String get home => '首页';

  @override
  String get streamDemoTitle => '实时食谱数量（响应式流）';

  @override
  String recipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 道食谱',
      one: '1 道食谱',
      zero: '没有食谱',
    );
    return '$_temp0';
  }

  @override
  String get myRecipes => '我的食谱';

  @override
  String get myRecipesSubtitle => '发现与管理你喜爱的食谱';

  @override
  String get searchRecipesHint => '搜索食谱…';

  @override
  String get sortRecipesTooltip => '排序食谱';

  @override
  String get sortSheetTitle => '排序方式';

  @override
  String get sortTitleAZ => '标题 A–Z';

  @override
  String get sortTitleZA => '标题 Z–A';

  @override
  String get sortPrepShortFirst => '准备时间（由短到长）';

  @override
  String get sortPrepLongFirst => '准备时间（由长到短）';

  @override
  String get allTypes => '全部类型';

  @override
  String get newRecipe => '新建食谱';

  @override
  String recipesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 道食谱',
      one: '找到 1 道食谱',
      zero: '未找到食谱',
    );
    return '$_temp0';
  }

  @override
  String prepTimeMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟',
      one: '1 分钟',
    );
    return '$_temp0';
  }

  @override
  String servingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人份',
      one: '1 人份',
    );
    return '$_temp0';
  }

  @override
  String get noRecipesMatch => '没有符合搜索或筛选条件的食谱。';

  @override
  String get backToRecipes => '返回食谱列表';

  @override
  String get createRecipeTitle => '创建新食谱';

  @override
  String get recipeTitleLabel => '食谱标题 *';

  @override
  String get recipeDescriptionLabel => '描述';

  @override
  String get recipeDescriptionHint => '可选简短摘要（与内置 recipes.json 类似）。';

  @override
  String get recipeTypeLabel => '食谱类型 *';

  @override
  String get selectRecipeTypeHint => '选择类型';

  @override
  String get prepTimeLabel => '准备时间 *';

  @override
  String get prepTimeHint => '例如：30 或 30 分钟';

  @override
  String get servingsLabel => '份数 *';

  @override
  String get servingsHint => '例如：4';

  @override
  String get prepTimeInvalid => '请输入包含数字的准备时间（例如 15 或 20 分钟）。';

  @override
  String get servingsInvalid => '请输入大于等于 1 的整数。';

  @override
  String get fieldRequired => '必填';

  @override
  String get recipePhotoLabel => '食谱照片';

  @override
  String get recipePhotoHelper => '可选。可在手机上从相册或相机选择。若跳过，将使用默认图片。';

  @override
  String get recipePhotoWebNote =>
      '照片选择在移动与桌面应用中可用。此处除非针对带相册/相机的平台构建，否则将使用默认图片。';

  @override
  String get pickFromGallery => '相册';

  @override
  String get takePhoto => '拍照';

  @override
  String get clearPhoto => '移除照片';

  @override
  String get ingredientsSectionLabel => '食材 *';

  @override
  String get addIngredient => '+ 添加食材';

  @override
  String ingredientHint(int n) {
    return '食材 $n';
  }

  @override
  String get stepsSectionLabel => '步骤 *';

  @override
  String get addStep => '+ 添加步骤';

  @override
  String stepHint(int n) {
    return '步骤 $n';
  }

  @override
  String get cancel => '取消';

  @override
  String get dialogConfirm => '确认';

  @override
  String get createRecipeSubmit => '创建食谱';

  @override
  String get createRecipeFailed => '无法保存食谱。';

  @override
  String get recipeTypeRequired => '请选择食谱类型。';

  @override
  String get ingredientsRequired => '请至少添加一项食材。';

  @override
  String get stepsRequired => '请至少添加一个步骤。';

  @override
  String get recipeNotFound => '未找到食谱';

  @override
  String get recipeNotFoundMessage => '该食谱可能已被删除或不再可用。';

  @override
  String get editRecipe => '编辑';

  @override
  String get deleteRecipe => '删除';

  @override
  String get deleteRecipeTitle => '删除食谱？';

  @override
  String get deleteRecipeMessage => '此操作无法撤销。食谱将从本机移除。';

  @override
  String get deleteRecipeConfirm => '删除';

  @override
  String get deleteRecipeFailed => '无法删除食谱。';

  @override
  String get ingredientsHeading => '食材';

  @override
  String get instructionsHeading => '做法';

  @override
  String get recipeUpdated => '食谱已更新。';

  @override
  String get editRecipeTitle => '编辑食谱';

  @override
  String get saveRecipeChanges => '保存更改';

  @override
  String get settingsCloudBackupSection => '云备份';

  @override
  String get settingsSyncToCloud => '同步到云端';

  @override
  String get settingsRestoreFromCloud => '从云端恢复';

  @override
  String get cloudSyncRequiresGoogle => '请使用 Google 登录以使用云备份。';

  @override
  String get cloudSyncDialogTitle => '同步到云端';

  @override
  String get cloudSyncDialogSubtitle => '云端将与本机一致：上传、更新，并删除云端多余的食谱。';

  @override
  String get cloudRestoreDialogTitle => '从云端恢复';

  @override
  String get cloudRestoreDialogSubtitle => '本机将与云端一致：下载、更新，并删除本机多余的食谱。';

  @override
  String get cloudDiffLoading => '正在对比本机与云端…';

  @override
  String get cloudDiffOnlyOnDeviceSync => '仅在本机 — 将上传到云端';

  @override
  String get cloudDiffOnlyInCloudSync => '仅在云端 — 将从云端删除';

  @override
  String get cloudDiffOnBothSync => '两边都有 — 云端副本将由本机覆盖';

  @override
  String get cloudDiffOnlyOnDeviceRestore => '仅在本机 — 将从本机删除';

  @override
  String get cloudDiffOnlyInCloudRestore => '仅在云端 — 将下载到本机';

  @override
  String get cloudDiffOnBothRestore => '两边都有 — 本机副本将由云端覆盖';

  @override
  String get cloudSyncRunConfirm => '应用同步';

  @override
  String get cloudRestoreRunConfirm => '应用恢复';

  @override
  String get cloudBackupCancel => '取消';

  @override
  String get cloudBackupDone => '云备份已更新。';

  @override
  String get cloudRestoreDone => '已从云端恢复。';

  @override
  String get cloudNoRecipesInSection => '无';

  @override
  String get settingsDiscoverSection => '探索';

  @override
  String get drawerDiscoverRecipes => '随机发现食谱';

  @override
  String get discoverRecipesTitle => '发现食谱';

  @override
  String get discoverRecipesSubtitle => '来自 TheMealDB 的随机餐点';

  @override
  String get discoverLoadTenButton => '随机加载 10 道食谱';

  @override
  String discoverFetchProgress(int done, int total) {
    return '已完成 $done / $total 次请求';
  }

  @override
  String get discoverEmptyHint => '点击上方按钮，从 TheMealDB 随机加载十道餐点（每次请求依次进行）。';

  @override
  String get discoverErrorAllFailed => '所有请求均失败。请检查网络后重试。';

  @override
  String get discoverErrorNoRecipes => '未返回任何食谱。请重试。';

  @override
  String discoverSomeRequestsFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次请求失败',
      one: '1 次请求失败',
    );
    return '$_temp0';
  }

  @override
  String get discoverPrepOnImport => '保存时再填写准备时间';

  @override
  String get discoverServingsOnImport => '保存时再填写份数';

  @override
  String get discoverUnknownCategory => 'TheMealDB';

  @override
  String get discoverBackToList => '返回发现页';

  @override
  String get discoverDetailImportCta => '添加到我的食谱';

  @override
  String get importRecipeTitle => '添加到我的食谱';

  @override
  String get importRecipeSavedMessage => '食谱已加入你的收藏。';
}

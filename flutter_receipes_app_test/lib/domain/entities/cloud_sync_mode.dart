/// Manual cloud backup direction shown in the comparison dialog.
enum CloudSyncMode {
  /// Device is source of truth; update Firestore to match local.
  sync,

  /// Cloud is source of truth; update device to match Firestore.
  restore,
}

enum UserPermission {
  aksesBiaya,
  aksesProses,
  aksesLaporan,
  aksesKasbon,
  updateStatusKasbon,
  aksesPostingJurnal,
  aksesKeuangan,
}

extension UserPermissionExtension on UserPermission {
  String get value {
    switch (this) {
      case UserPermission.aksesBiaya:
        return 'Akses Biaya';
      case UserPermission.aksesProses:
        return 'Akses Proses';
      case UserPermission.aksesLaporan:
        return 'Akses Keuangan';
      case UserPermission.aksesKasbon:
        return 'Akses Kasbon';
      case UserPermission.updateStatusKasbon:
        return 'Update Status Kasbon';
      case UserPermission.aksesPostingJurnal:
        return 'Akses Posting Jurnal';
      case UserPermission.aksesKeuangan:
        return 'Akses Keuangan';
    }
  }
}

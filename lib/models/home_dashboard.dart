class HomeDashboard {
  final double saldoKasbon;
  final int totalKasbon;
  final int totalPengeluaran;
  final int totalProses;
  final int totalBiaya;
  final int notificationCount;
  final String name;

  const HomeDashboard({
    required this.saldoKasbon,
    required this.totalKasbon,
    required this.totalPengeluaran,
    required this.totalProses,
    required this.totalBiaya,
    required this.notificationCount,
    required this.name,
  });

  factory HomeDashboard.fromJson(Map<String, dynamic> json) {
    return HomeDashboard(
      saldoKasbon: (json["saldo_kasbon"] ?? 0).toDouble(),

      totalKasbon: json["total_kasbon"] ?? 0,

      totalPengeluaran: json["total_pengeluaran"] ?? 0,

      totalProses: json["total_proses"] ?? 0,

      totalBiaya: json["total_biaya"] ?? 0,
      name: json["name"] ?? "",

      notificationCount: json["notification"] ?? 0,
    );
  }
}

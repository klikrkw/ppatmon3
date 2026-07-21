class AddKeluarbiayapermuserRequest {
  final int userId;
  final int instansiId;

  final int metodebayarId;

  final int rekeningId;

  final String? kasbonId;

  final double saldoAwal;

  final double jumlahBiaya;

  final double saldoAkhir;

  const AddKeluarbiayapermuserRequest({
    required this.userId,
    required this.instansiId,
    required this.metodebayarId,
    required this.rekeningId,
    this.kasbonId,
    required this.saldoAwal,
    required this.jumlahBiaya,
    required this.saldoAkhir,
  });

  Map<String, dynamic> toMap() {
    return {
      "user_id": userId,
      "instansi_id": instansiId,
      "metodebayar_id": metodebayarId,
      "rekening_id": rekeningId,
      "kasbon_id": kasbonId,
      "saldo_awal": saldoAwal,
      "jumlah_biaya": jumlahBiaya,
      "saldo_akhir": saldoAkhir,
    };
  }
}

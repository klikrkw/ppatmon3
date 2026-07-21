class Rekening {
  final int id;
  final String namaRekening;
  final String ketRekening;
  final int akunId;
  final int metodebayarId;

  const Rekening({
    required this.id,
    required this.namaRekening,
    required this.ketRekening,
    required this.akunId,
    required this.metodebayarId,
  });

  factory Rekening.fromJson(Map<String, dynamic> json) {
    return Rekening(
      id: json['id'],
      namaRekening: json['nama_rekening'] ?? '',
      ketRekening: json['ket_rekening'] ?? '',
      akunId: json['akun_id'] ?? 0,
      metodebayarId: json['metodebayar_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_rekening': namaRekening,
      'ket_rekening': ketRekening,
      'akun_id': akunId,
      'metodebayar_id': metodebayarId,
    };
  }

  Rekening copyWith({
    int? id,
    String? namaRekening,
    String? ketRekening,
    int? akunId,
    int? metodebayarId,
  }) {
    return Rekening(
      id: id ?? this.id,
      namaRekening: namaRekening ?? this.namaRekening,
      ketRekening: ketRekening ?? this.ketRekening,
      akunId: akunId ?? this.akunId,
      metodebayarId: metodebayarId ?? this.metodebayarId,
    );
  }

  @override
  String toString() => namaRekening;
}

class Metodebayar {
  final int id;
  final String namaMetodebayar;
  final int akunId;

  const Metodebayar({
    required this.id,
    required this.namaMetodebayar,
    required this.akunId,
  });

  factory Metodebayar.fromJson(Map<String, dynamic> json) {
    return Metodebayar(
      id: json['id'],
      namaMetodebayar: json['nama_metodebayar'] ?? '',
      akunId: json['akun_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama_metodebayar': namaMetodebayar, 'akun_id': akunId};
  }

  Metodebayar copyWith({int? id, String? namaMetodebayar, int? akunId}) {
    return Metodebayar(
      id: id ?? this.id,
      namaMetodebayar: namaMetodebayar ?? this.namaMetodebayar,
      akunId: akunId ?? this.akunId,
    );
  }

  @override
  String toString() => namaMetodebayar;
}

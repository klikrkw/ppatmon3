class Desa {
  final String id;
  final String namaDesa;
  final String namaKecamatan;

  const Desa({
    required this.id,
    required this.namaDesa,
    required this.namaKecamatan,
  });

  factory Desa.fromJson(Map<String, dynamic> json) {
    return Desa(
      id: json['id']?.toString() ?? '',
      namaDesa: json['nama_desa'] ?? '',
      namaKecamatan: json['nama_kecamatan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama_desa': namaDesa, 'nama_kecamatan': namaKecamatan};
  }

  @override
  String toString() => "$namaDesa - $namaKecamatan";
}

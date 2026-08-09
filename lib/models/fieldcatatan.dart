class Fieldcatatan {
  final int id;
  final String namaFieldcatatan;

  const Fieldcatatan({required this.id, required this.namaFieldcatatan});

  factory Fieldcatatan.fromJson(Map<String, dynamic> json) {
    return Fieldcatatan(
      id: json['id'] ?? 0,
      namaFieldcatatan: json['nama_fieldcatatan'] ?? '',
    );
  }
}

class Kantor {
  final int id;
  final String namaKantor;
  final String alamatKantor;
  final String imageKantor;

  const Kantor({
    required this.id,
    required this.namaKantor,
    required this.alamatKantor,
    required this.imageKantor,
  });

  factory Kantor.fromJson(Map<String, dynamic> json) {
    return Kantor(
      id: json['id'] ?? 0,
      namaKantor: json['nama_kantor'] ?? '',
      alamatKantor: json['alamat_kantor'] ?? '',
      imageKantor: json['image_kantor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kantor': namaKantor,
      'alamat_kantor': alamatKantor,
      'image_kantor': imageKantor,
    };
  }
}

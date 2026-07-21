class Jenistempatarsip {
  final int id;
  final String namaJenistempatarsip;
  final String imageJenistempatarsip;

  const Jenistempatarsip({
    required this.id,
    required this.namaJenistempatarsip,
    required this.imageJenistempatarsip,
  });

  factory Jenistempatarsip.fromJson(Map<String, dynamic> json) {
    return Jenistempatarsip(
      id: json['id'] ?? 0,
      namaJenistempatarsip: json['nama_jenistempatarsip'] ?? '',
      imageJenistempatarsip: json['image_jenistempatarsip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_jenistempatarsip': namaJenistempatarsip,
      'image_jenistempatarsip': imageJenistempatarsip,
    };
  }
}

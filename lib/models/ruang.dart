import 'package:newklikrkw/models/kantor.dart';

class Ruang {
  final int id;
  final String namaRuang;
  final Kantor kantor;
  final String imageRuang;

  const Ruang({
    required this.id,
    required this.namaRuang,
    required this.kantor,
    required this.imageRuang,
  });

  factory Ruang.fromJson(Map<String, dynamic> json) {
    return Ruang(
      id: json['id'] ?? 0,
      namaRuang: json['nama_ruang'] ?? '',
      kantor: Kantor.fromJson(json['kantor'] ?? {}),
      imageRuang: json['image_ruang'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_ruang': namaRuang,
      'kantor': kantor.toJson(),
      'image_ruang': imageRuang,
    };
  }
}

import 'itemkegiatan.dart';

class Dkasbonnoperm {
  final String id;
  final Itemkegiatan? itemkegiatan;
  final double jumlahBiaya;
  final String ketBiaya;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Dkasbonnoperm({
    required this.id,
    required this.itemkegiatan,
    required this.jumlahBiaya,
    required this.ketBiaya,
    this.createdAt,
    this.updatedAt,
  });

  factory Dkasbonnoperm.fromJson(Map<String, dynamic> json) {
    return Dkasbonnoperm(
      id: json['id'] ?? 0,
      itemkegiatan: json['itemkegiatan'] != null
          ? Itemkegiatan.fromJson(json['itemkegiatan'])
          : null,
      jumlahBiaya: double.tryParse(json['jumlah_biaya'].toString()) ?? 0,
      ketBiaya: json['ket_biaya'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

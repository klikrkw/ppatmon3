import 'package:newklikrkw/models/transpermohonan.dart';

import 'itemkegiatan.dart';

class Dkasbon {
  final String id;
  final Itemkegiatan? itemkegiatan;
  final Transpermohonan? transpermohonan;
  final double jumlahBiaya;
  final String? ketBiaya;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Dkasbon({
    required this.id,
    required this.itemkegiatan,
    required this.jumlahBiaya,
    required this.ketBiaya,
    required this.transpermohonan,
    this.createdAt,
    this.updatedAt,
  });

  factory Dkasbon.fromJson(Map<String, dynamic> json) {
    return Dkasbon(
      id: json['id'] ?? 0,
      transpermohonan: Transpermohonan.fromJson(json['transpermohonan']),
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

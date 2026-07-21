//`id`, `jumlah_kasbon`, `jumlah_penggunaan`, `sisa_penggunaan`, `keperluan`, `user_id`, `status_kasbon`, `created_at`, `updated_at`, `instansi_id`, `jenis_kasbon`
// 'wait_approval','approved','cancelled','used','finish'

import 'package:newklikrkw/models/instansi.dart';
import 'package:newklikrkw/models/user.dart';

enum JenisKasbon { permohonan, nonPermohonan }

enum StatusKasbon { waitApproval, approved, cancelled, used, finish }

class Kasbon {
  final String id;
  final double jumlahKasbon;
  final double jumlahPenggunaan;
  final double sisaPenggunaan;
  final String? keperluan;
  // final int userId;
  final String statusKasbon;
  final String createdAt;
  final String updatedAt;
  // final int instansiId;
  final String jenisKasbon;
  final User? user;
  final Instansi instansi;

  Kasbon({
    required this.id,
    required this.jumlahKasbon,
    required this.jumlahPenggunaan,
    required this.sisaPenggunaan,
    this.keperluan,
    // required this.userId,
    required this.statusKasbon,
    required this.createdAt,
    required this.updatedAt,
    // required this.instansiId,
    required this.jenisKasbon,
    this.user,
    required this.instansi,
  });

  factory Kasbon.fromJson(Map<String, dynamic> json) => Kasbon(
    id: json['id'],
    jumlahKasbon: (json['jumlah_kasbon'] as num).toDouble(),
    jumlahPenggunaan: (json['jumlah_penggunaan'] as num).toDouble(),
    sisaPenggunaan: (json['sisa_penggunaan'] as num).toDouble(),
    keperluan: json['keperluan'],
    // userId: json['user_id'],
    statusKasbon: json['status_kasbon'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    // instansiId: json['instansi_id'],
    jenisKasbon: json['jenis_kasbon'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    instansi: Instansi.fromJson(json['instansi']),
  );
  static Map<String, dynamic> toJson(Kasbon kasbon) => {
    'id': kasbon.id,
    'jumlah_kasbon': kasbon.jumlahKasbon,
    'jumlah_penggunaan': kasbon.jumlahPenggunaan,
    'sisa_penggunaan': kasbon.sisaPenggunaan,
    'keperluan': kasbon.keperluan,
    // 'user_id': kasbon.userId,
    'status_kasbon': kasbon.statusKasbon,
    'created_at': kasbon.createdAt,
    'updated_at': kasbon.updatedAt,
    // 'instansi_id': kasbon.instansiId,
    'jenis_kasbon': kasbon.jenisKasbon,
    'user': kasbon.user,
    'instansi': kasbon.instansi,
  };
  static List<Kasbon> fromJsonList(List<dynamic> json) =>
      json.map((e) => Kasbon.fromJson(e)).toList();
}

class AddKasbonRequest {
  final double jumlahKasbon;
  final double jumlahPenggunaan;
  final double sisaPenggunaan;
  final String keperluan;
  final String jenisKasbon;
  final String statusKasbon;
  final int userId;
  final int instansiId;

  AddKasbonRequest({
    required this.jumlahKasbon,
    required this.jumlahPenggunaan,
    required this.sisaPenggunaan,
    required this.keperluan,
    required this.jenisKasbon,
    required this.statusKasbon,
    required this.userId,
    required this.instansiId,
  });

  Map<String, dynamic> toJson() {
    return {
      'jumlah_kasbon': jumlahKasbon,
      'jumlah_penggunaan': jumlahPenggunaan,
      'sisa_penggunaan': sisaPenggunaan,
      'keperluan': keperluan,
      'jenis_kasbon': jenisKasbon,
      'status_kasbon': statusKasbon,
      'user_id': userId,
      'instansi_id': instansiId,
    };
  }
}

class UpdateKasbonRequest {
  final String jenisKasbon;
  final double jumlahBiaya;
  final int itemkegiatanId;
  final String ketBiaya;

  UpdateKasbonRequest({
    required this.jenisKasbon,
    required this.jumlahBiaya,
    required this.itemkegiatanId,
    required this.ketBiaya,
  });
  Map<String, dynamic> toJson() {
    return {
      'jenis_kasbon': jenisKasbon,
      'jumlah_biaya': jumlahBiaya,
      'itemkegiatan_id': itemkegiatanId,
      'ket_biaya': ketBiaya,
    };
  }
}

class UpdateKasbonPermRequest {
  final String jenisKasbon;
  final double jumlahBiaya;
  final int itemkegiatanId;
  final String transpermohonanId;
  final String ketBiaya;

  UpdateKasbonPermRequest({
    required this.jenisKasbon,
    required this.jumlahBiaya,
    required this.itemkegiatanId,
    required this.transpermohonanId,
    required this.ketBiaya,
  });
  Map<String, dynamic> toJson() {
    return {
      'jenis_kasbon': jenisKasbon,
      'jumlah_biaya': jumlahBiaya,
      'itemkegiatan_id': itemkegiatanId,
      'transpermohonan_id': transpermohonanId,
      'ket_biaya': ketBiaya,
    };
  }
}

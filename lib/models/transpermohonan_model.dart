import 'package:newklikrkw/models/desa.dart';
import 'package:newklikrkw/models/jenishak.dart';
import 'package:newklikrkw/models/jenispermohonan.dart';
import 'package:newklikrkw/models/user.dart';

enum PeriodCekBiaya { forever, limited }

class TranspermohonanModel {
  final String id;
  final String namaPelepas;
  final String namaPenerima;
  final Jenishak jenishak;
  final String nomorHak;
  final String persil;
  final String klas;
  final int luasTanah;
  final int bidang;
  final String atasNama;
  final String jenisTanah;
  final Desa desa;
  final int nodaftarPermohonan;
  final int thdaftarPermohonan;
  final String kodeUnik;
  final bool active;
  final bool cekBiaya;
  final String periodCekbiaya;
  final DateTime? dateCekbiaya;
  final List<User> users;
  final List<Jenispermohonan> jenispermohonans;

  const TranspermohonanModel({
    required this.id,
    required this.namaPelepas,
    required this.namaPenerima,
    required this.jenishak,
    required this.nomorHak,
    required this.persil,
    required this.klas,
    required this.luasTanah,
    required this.atasNama,
    required this.jenisTanah,
    required this.desa,
    required this.nodaftarPermohonan,
    required this.thdaftarPermohonan,
    required this.kodeUnik,
    required this.active,
    required this.cekBiaya,
    required this.periodCekbiaya,
    this.dateCekbiaya,
    required this.users,
    required this.jenispermohonans,
    required this.bidang,
  });

  factory TranspermohonanModel.fromJson(Map<String, dynamic> json) {
    return TranspermohonanModel(
      id: json['id'] ?? '',
      namaPelepas: json['nama_pelepas'] ?? '',
      namaPenerima: json['nama_penerima'] ?? '',
      jenishak: Jenishak.fromJson(json['jenishak'] ?? {}),
      nomorHak: json['nomor_hak'] ?? '',
      persil: json['persil'] ?? '',
      klas: json['klas'] ?? '',
      luasTanah: json['luas_tanah'] ?? 0,
      atasNama: json['atas_nama'] ?? '',
      jenisTanah: json['jenis_tanah'] ?? '',
      desa: Desa.fromJson(json['desa'] ?? {}),
      nodaftarPermohonan: json['nodaftar_permohonan'] ?? 0,
      thdaftarPermohonan: json['thdaftar_permohonan'] ?? 0,
      kodeUnik: json['kode_unik'] ?? '',
      active: json['active'] ?? false,
      cekBiaya: json['cek_biaya'] ?? false,
      periodCekbiaya: json['period_cekbiaya'],
      dateCekbiaya:
          json['date_cekbiaya'] == null ||
              json['date_cekbiaya'].toString().isEmpty
          ? null
          : DateTime.parse(json['date_cekbiaya']),
      users: (json['users'] as List<dynamic>? ?? [])
          .map((e) => User.fromJson(e))
          .toList(),
      jenispermohonans: (json['jenispermohonans'] as List<dynamic>? ?? [])
          .map((e) => Jenispermohonan.fromJson(e))
          .toList(),
      bidang: json['bidang'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_pelepas': namaPelepas,
      'nama_penerima': namaPenerima,
      'jenishak': jenishak.toJson(),
      'nomor_hak': nomorHak,
      'persil': persil,
      'klas': klas,
      'luas_tanah': luasTanah,
      'atas_nama': atasNama,
      'jenis_tanah': jenisTanah,
      'desa': desa.toJson(),
      'nodaftar_permohonan': nodaftarPermohonan,
      'thdaftar_permohonan': thdaftarPermohonan,
      'kode_unik': kodeUnik,
      'active': active,
      'cek_biaya': cekBiaya,
      'period_cekbiaya': periodCekbiaya,
      'date_cekbiaya': dateCekbiaya?.toIso8601String(),
      'users': users.map((e) => e.toJson()).toList(),
      'jenispermohonans': jenispermohonans.map((e) => e.toJson()).toList(),
      'bidang': bidang,
    };
  }

  TranspermohonanModel copyWith({
    String? id,
    String? namaPelepas,
    String? namaPenerima,
    Jenishak? jenishak,
    String? nomorHak,
    String? persil,
    String? klas,
    int? luasTanah,
    String? atasNama,
    String? jenisTanah,
    Desa? desa,
    int? nodaftarPermohonan,
    int? thdaftarPermohonan,
    String? kodeUnik,
    bool? active,
    bool? cekBiaya,
    String? periodCekbiaya,
    DateTime? dateCekbiaya,
    List<User>? users,
    List<Jenispermohonan>? jenispermohonans,
    int? bidang,
  }) {
    return TranspermohonanModel(
      id: id ?? this.id,
      namaPelepas: namaPelepas ?? this.namaPelepas,
      namaPenerima: namaPenerima ?? this.namaPenerima,
      jenishak: jenishak ?? this.jenishak,
      nomorHak: nomorHak ?? this.nomorHak,
      persil: persil ?? this.persil,
      klas: klas ?? this.klas,
      luasTanah: luasTanah ?? this.luasTanah,
      atasNama: atasNama ?? this.atasNama,
      jenisTanah: jenisTanah ?? this.jenisTanah,
      desa: desa ?? this.desa,
      nodaftarPermohonan: nodaftarPermohonan ?? this.nodaftarPermohonan,
      thdaftarPermohonan: thdaftarPermohonan ?? this.thdaftarPermohonan,
      kodeUnik: kodeUnik ?? this.kodeUnik,
      active: active ?? this.active,
      cekBiaya: cekBiaya ?? this.cekBiaya,
      periodCekbiaya: periodCekbiaya ?? this.periodCekbiaya,
      dateCekbiaya: dateCekbiaya ?? this.dateCekbiaya,
      users: users ?? this.users,
      jenispermohonans: jenispermohonans ?? this.jenispermohonans,
      bidang: bidang ?? this.bidang,
    );
  }
}

import 'package:newklikrkw/models/user.dart';

class Transpermohonan {
  final String id;
  final String noDaftar;
  final String tglDaftar;
  final String namaPelepas;
  final String namaPenerima;
  final String jenisPermohonan;
  final String alasHak;
  final String letakObyek;
  final bool active;
  final List<User> users;

  Transpermohonan({
    required this.id,
    required this.noDaftar,
    required this.tglDaftar,
    required this.namaPelepas,
    required this.namaPenerima,
    required this.jenisPermohonan,
    required this.alasHak,
    required this.letakObyek,
    required this.active,
    this.users = const [],
  });
  Transpermohonan copyWith({bool? active}) {
    return Transpermohonan(
      id: id,
      noDaftar: noDaftar,
      tglDaftar: tglDaftar,
      namaPelepas: namaPelepas,
      namaPenerima: namaPenerima,
      jenisPermohonan: jenisPermohonan,
      alasHak: alasHak,
      letakObyek: letakObyek,
      active: active ?? this.active,
    );
  }

  factory Transpermohonan.fromJson(Map<String, dynamic> json) {
    return Transpermohonan(
      id: json['id'] ?? '',
      noDaftar: json['no_daftar'] ?? '',
      tglDaftar: json['tgl_daftar'] ?? '',
      namaPelepas: json['nama_pelepas'] ?? '',
      namaPenerima: json['nama_penerima'] ?? '',
      jenisPermohonan: json['jenis_permohonan'] ?? '',
      alasHak: json['alas_hak'] ?? '',
      letakObyek: json['letak_obyek'] ?? '',
      active: json['active'] ?? false,
      users:
          (json['users'] as List?)?.map((e) => User.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_daftar': noDaftar,
      'tgl_daftar': tglDaftar,
      'nama_pelepas': namaPelepas,
      'nama_penerima': namaPenerima,
      'jenis_permohonan': jenisPermohonan,
      'alas_hak': alasHak,
      'letak_obyek': letakObyek,
      'active': active,
    };
  }
}

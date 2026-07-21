import 'package:equatable/equatable.dart';

class Bukubesar extends Equatable {
  final String id;
  final DateTime? createdAt;

  final String kodeJenisakun;
  final String kodeAkun;
  final String namaAkun;
  final String uraian;

  final double debet;
  final double kredit;

  final int noUrut;
  final int noRut;

  final DateTime? tanggal;

  final double saldo;

  const Bukubesar({
    required this.id,
    this.createdAt,
    required this.kodeJenisakun,
    required this.kodeAkun,
    required this.namaAkun,
    required this.uraian,
    required this.debet,
    required this.kredit,
    required this.noUrut,
    required this.noRut,
    this.tanggal,
    required this.saldo,
  });

  String get jenisTransaksi => isDebet ? "Debet" : "Kredit";
  double get jumlah => isDebet ? debet : kredit;
  bool get isMinus => kredit > 0;

  factory Bukubesar.fromJson(Map<String, dynamic> json) {
    return Bukubesar(
      id: json['id'] ?? '',

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      kodeJenisakun: json['kode_jenisakun'] ?? '',

      kodeAkun: json['kode_akun'] ?? '',

      namaAkun: json['nama_akun'] ?? '',

      uraian: json['uraian'] ?? '',

      debet: (json['debet'] ?? 0).toDouble(),

      kredit: (json['kredit'] ?? 0).toDouble(),

      noUrut: json['no_urut'] ?? 0,

      noRut: json['nourut'] ?? 0,

      tanggal: json['tanggal'] != null
          ? DateTime.tryParse(json['tanggal'])
          : null,

      saldo: (json['saldo'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt?.toIso8601String(),
      "kode_jenisakun": kodeJenisakun,
      "kode_akun": kodeAkun,
      "nama_akun": namaAkun,
      "uraian": uraian,
      "debet": debet,
      "kredit": kredit,
      "no_urut": noUrut,
      "nourut": noRut,
      "tanggal": tanggal?.toIso8601String(),
      "saldo": saldo,
    };
  }

  bool get isDebet => debet > 0;

  bool get isKredit => kredit > 0;

  double get nominal => isDebet ? debet : kredit;

  @override
  List<Object?> get props => [
    id,
    createdAt,
    kodeJenisakun,
    kodeAkun,
    namaAkun,
    uraian,
    debet,
    kredit,
    noUrut,
    noRut,
    tanggal,
    saldo,
  ];
}

import 'package:newklikrkw/models/user.dart';

import 'metodebayar.dart';
import 'rekening.dart';

class Bayarbiayaperm {
  final String id;

  final DateTime tglBayarbiayaperm;

  final Metodebayar metodebayar;

  final String infoRekening;

  final double saldoAwal;

  final double jumlahBayar;

  final double saldoAkhir;

  final User user;

  final String catatanBayarbiayaperm;

  final String imageBayarbiayaperm;

  final Rekening rekening;
  bool get hasImage => imageBayarbiayaperm.isNotEmpty;

  const Bayarbiayaperm({
    required this.id,
    required this.tglBayarbiayaperm,
    required this.metodebayar,
    required this.infoRekening,
    required this.saldoAwal,
    required this.jumlahBayar,
    required this.saldoAkhir,
    required this.user,
    required this.catatanBayarbiayaperm,
    required this.imageBayarbiayaperm,
    required this.rekening,
  });

  factory Bayarbiayaperm.fromJson(Map<String, dynamic> json) {
    return Bayarbiayaperm(
      id: json['id'] ?? '',

      tglBayarbiayaperm: DateTime.parse(json['tgl_bayarbiayaperm']),

      metodebayar: Metodebayar.fromJson(json['metodebayar']),

      infoRekening: json['info_rekening'] ?? '',

      saldoAwal: (json['saldo_awal'] ?? 0).toDouble(),

      jumlahBayar: (json['jumlah_bayar'] ?? 0).toDouble(),

      saldoAkhir: (json['saldo_akhir'] ?? 0).toDouble(),

      user: User.fromJson(json['user']),

      catatanBayarbiayaperm: json['catatan_bayarbiayaperm'] ?? '',

      imageBayarbiayaperm: json['image_bayarbiayaperm'] ?? '',

      rekening: Rekening.fromJson(json['rekening']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tgl_bayarbiayaperm': tglBayarbiayaperm.toIso8601String(),
      'metodebayar': metodebayar.toJson(),
      'info_rekening': infoRekening,
      'saldo_awal': saldoAwal,
      'jumlah_bayar': jumlahBayar,
      'saldo_akhir': saldoAkhir,
      'user': user.toJson(),
      'catatan_bayarbiayaperm': catatanBayarbiayaperm,
      'image_bayarbiayaperm': imageBayarbiayaperm,
      'rekening': rekening.toJson(),
    };
  }

  Bayarbiayaperm copyWith({
    String? id,
    DateTime? tglBayarbiayaperm,
    Metodebayar? metodebayar,
    String? infoRekening,
    double? saldoAwal,
    double? jumlahBayar,
    double? saldoAkhir,
    User? user,
    String? catatanBayarbiayaperm,
    String? imageBayarbiayaperm,
    Rekening? rekening,
  }) {
    return Bayarbiayaperm(
      id: id ?? this.id,
      tglBayarbiayaperm: tglBayarbiayaperm ?? this.tglBayarbiayaperm,
      metodebayar: metodebayar ?? this.metodebayar,
      infoRekening: infoRekening ?? this.infoRekening,
      saldoAwal: saldoAwal ?? this.saldoAwal,
      jumlahBayar: jumlahBayar ?? this.jumlahBayar,
      saldoAkhir: saldoAkhir ?? this.saldoAkhir,
      user: user ?? this.user,
      catatanBayarbiayaperm:
          catatanBayarbiayaperm ?? this.catatanBayarbiayaperm,
      imageBayarbiayaperm: imageBayarbiayaperm ?? this.imageBayarbiayaperm,
      rekening: rekening ?? this.rekening,
    );
  }
}

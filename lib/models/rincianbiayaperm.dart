import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/models/user.dart';

class Rincianbiayaperm {
  final String id;

  final Transpermohonan transpermohonan;

  final String ketRincianbiayaperm;

  final User user;

  final String statusRincianbiayaperm;

  final double totalPemasukan;
  final double totalPengeluaran;
  final double totalPiutang;
  final double sisaSaldo;

  final int metodebayarId;
  final int rekeningId;

  const Rincianbiayaperm({
    required this.id,
    required this.transpermohonan,
    required this.ketRincianbiayaperm,
    required this.user,
    required this.statusRincianbiayaperm,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.totalPiutang,
    required this.sisaSaldo,
    required this.metodebayarId,
    required this.rekeningId,
  });

  factory Rincianbiayaperm.fromJson(Map<String, dynamic> json) {
    return Rincianbiayaperm(
      id: json['id']?.toString() ?? '',

      transpermohonan: Transpermohonan.fromJson(json['transpermohonan'] ?? {}),

      ketRincianbiayaperm: json['ket_rincianbiayaperm'] ?? '',

      user: User.fromJson(json['user'] ?? {}),

      statusRincianbiayaperm: json['status_rincianbiayaperm'] ?? '',

      totalPemasukan: (json['total_pemasukan'] ?? 0).toDouble(),

      totalPengeluaran: (json['total_pengeluaran'] ?? 0).toDouble(),

      totalPiutang: (json['total_piutang'] ?? 0).toDouble(),

      sisaSaldo: (json['sisa_saldo'] ?? 0).toDouble(),

      metodebayarId: json['metodebayar_id'] ?? 0,

      rekeningId: json['rekening_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'transpermohonan': transpermohonan.toJson(),

      'ket_rincianbiayaperm': ketRincianbiayaperm,

      'user': user.toJson(),

      'status_rincianbiayaperm': statusRincianbiayaperm,

      'total_pemasukan': totalPemasukan,

      'total_pengeluaran': totalPengeluaran,

      'total_piutang': totalPiutang,

      'sisa_saldo': sisaSaldo,

      'metodebayar_id': metodebayarId,

      'rekening_id': rekeningId,
    };
  }

  Rincianbiayaperm copyWith({
    String? id,
    Transpermohonan? transpermohonan,
    String? ketRincianbiayaperm,
    User? user,
    String? statusRincianbiayaperm,
    double? totalPemasukan,
    double? totalPengeluaran,
    double? totalPiutang,
    double? sisaSaldo,
    int? metodebayarId,
    int? rekeningId,
  }) {
    return Rincianbiayaperm(
      id: id ?? this.id,
      transpermohonan: transpermohonan ?? this.transpermohonan,
      ketRincianbiayaperm: ketRincianbiayaperm ?? this.ketRincianbiayaperm,
      user: user ?? this.user,
      statusRincianbiayaperm:
          statusRincianbiayaperm ?? this.statusRincianbiayaperm,
      totalPemasukan: totalPemasukan ?? this.totalPemasukan,
      totalPengeluaran: totalPengeluaran ?? this.totalPengeluaran,
      totalPiutang: totalPiutang ?? this.totalPiutang,
      sisaSaldo: sisaSaldo ?? this.sisaSaldo,
      metodebayarId: metodebayarId ?? this.metodebayarId,
      rekeningId: rekeningId ?? this.rekeningId,
    );
  }
}

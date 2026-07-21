import 'package:newklikrkw/models/instansi.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/user.dart';

class Keluarbiayapermuser {
  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  final Metodebayar metodebayar;

  final Instansi instansi;

  final double jumlahKeluarbiaya;

  final User user;

  final String statusKeluarbiayapermuser;

  final double saldoAwal;

  final double jumlahBiaya;

  final double saldoAkhir;

  const Keluarbiayapermuser({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.metodebayar,
    required this.instansi,
    required this.jumlahKeluarbiaya,
    required this.user,
    required this.statusKeluarbiayapermuser,
    required this.saldoAwal,
    required this.jumlahBiaya,
    required this.saldoAkhir,
  });

  factory Keluarbiayapermuser.fromJson(Map<String, dynamic> json) {
    double parse(dynamic value) {
      return double.tryParse(value.toString()) ?? 0;
    }

    return Keluarbiayapermuser(
      id: json["id"] ?? "",

      createdAt: DateTime.parse(json["created_at"]),

      updatedAt: DateTime.parse(json["updated_at"]),

      metodebayar: Metodebayar.fromJson(json["metodebayar"]),

      instansi: Instansi.fromJson(json["instansi"]),

      jumlahKeluarbiaya: parse(json["jumlah_keluarbiaya"]),

      user: User.fromJson(json["user"]),

      statusKeluarbiayapermuser: json["status_keluarbiayapermuser"] ?? "",

      saldoAwal: parse(json["saldo_awal"]),

      jumlahBiaya: parse(json["jumlah_biaya"]),

      saldoAkhir: parse(json["saldo_akhir"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "metodebayar": metodebayar.toJson(),
      "instansi": instansi.toJson(),
      "jumlah_keluarbiaya": jumlahKeluarbiaya,
      "user": user.toJson(),
      "status_keluarbiaya": statusKeluarbiayapermuser,
      "saldo_awal": saldoAwal,
      "jumlah_biaya": jumlahBiaya,
      "saldo_akhir": saldoAkhir,
    };
  }

  Keluarbiayapermuser copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Metodebayar? metodebayar,
    Instansi? instansi,
    double? jumlahKeluarbiaya,
    User? user,
    String? statusKeluarbiayapermuser,
    double? saldoAwal,
    double? jumlahBiaya,
    double? saldoAkhir,
  }) {
    return Keluarbiayapermuser(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metodebayar: metodebayar ?? this.metodebayar,
      instansi: instansi ?? this.instansi,
      jumlahKeluarbiaya: jumlahKeluarbiaya ?? this.jumlahKeluarbiaya,
      user: user ?? this.user,
      statusKeluarbiayapermuser:
          statusKeluarbiayapermuser ?? this.statusKeluarbiayapermuser,
      saldoAwal: saldoAwal ?? this.saldoAwal,
      jumlahBiaya: jumlahBiaya ?? this.jumlahBiaya,
      saldoAkhir: saldoAkhir ?? this.saldoAkhir,
    );
  }
}

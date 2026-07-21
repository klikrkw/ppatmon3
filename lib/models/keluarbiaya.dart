import 'package:newklikrkw/models/instansi.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/user.dart';

class Keluarbiaya {
  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  final Metodebayar metodebayar;

  final Instansi instansi;

  final double jumlahKeluarbiaya;

  final String imageKeluarbiaya;

  final User user;

  final String statusKeluarbiaya;

  final double saldoAwal;

  final double jumlahBiaya;

  final double saldoAkhir;

  const Keluarbiaya({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.metodebayar,
    required this.instansi,
    required this.jumlahKeluarbiaya,
    required this.imageKeluarbiaya,
    required this.user,
    required this.statusKeluarbiaya,
    required this.saldoAwal,
    required this.jumlahBiaya,
    required this.saldoAkhir,
  });

  factory Keluarbiaya.fromJson(Map<String, dynamic> json) {
    double parse(dynamic value) {
      return double.tryParse(value.toString()) ?? 0;
    }

    return Keluarbiaya(
      id: json["id"] ?? "",

      createdAt: DateTime.parse(json["created_at"]),

      updatedAt: DateTime.parse(json["updated_at"]),

      metodebayar: Metodebayar.fromJson(json["metodebayar"]),

      instansi: Instansi.fromJson(json["instansi"]),

      jumlahKeluarbiaya: parse(json["jumlah_keluarbiaya"]),

      imageKeluarbiaya: json["image_keluarbiaya"] ?? "",

      user: User.fromJson(json["user"]),

      statusKeluarbiaya: json["status_keluarbiaya"] ?? "",

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
      "image_keluarbiaya": imageKeluarbiaya,
      "user": user.toJson(),
      "status_keluarbiaya": statusKeluarbiaya,
      "saldo_awal": saldoAwal,
      "jumlah_biaya": jumlahBiaya,
      "saldo_akhir": saldoAkhir,
    };
  }

  Keluarbiaya copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Metodebayar? metodebayar,
    Instansi? instansi,
    double? jumlahKeluarbiaya,
    String? imageKeluarbiaya,
    User? user,
    String? statusKeluarbiaya,
    double? saldoAwal,
    double? jumlahBiaya,
    double? saldoAkhir,
  }) {
    return Keluarbiaya(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metodebayar: metodebayar ?? this.metodebayar,
      instansi: instansi ?? this.instansi,
      jumlahKeluarbiaya: jumlahKeluarbiaya ?? this.jumlahKeluarbiaya,
      imageKeluarbiaya: imageKeluarbiaya ?? this.imageKeluarbiaya,
      user: user ?? this.user,
      statusKeluarbiaya: statusKeluarbiaya ?? this.statusKeluarbiaya,
      saldoAwal: saldoAwal ?? this.saldoAwal,
      jumlahBiaya: jumlahBiaya ?? this.jumlahBiaya,
      saldoAkhir: saldoAkhir ?? this.saldoAkhir,
    );
  }
}

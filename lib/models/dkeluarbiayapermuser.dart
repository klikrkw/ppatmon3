import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/transpermohonan.dart';

import 'itemkegiatan.dart';

class Dkeluarbiayapermuser extends Equatable {
  final String id;

  final DateTime? createdAt;

  final Itemkegiatan? itemkegiatan;
  final Transpermohonan? transpermohonan;

  final double jumlahBiaya;

  final String ketBiaya;

  final String imageDkeluarbiayapermuser;

  const Dkeluarbiayapermuser({
    required this.id,
    required this.createdAt,
    required this.itemkegiatan,
    required this.jumlahBiaya,
    required this.ketBiaya,
    required this.imageDkeluarbiayapermuser,
    required this.transpermohonan,
  });

  factory Dkeluarbiayapermuser.fromJson(Map<String, dynamic> json) {
    return Dkeluarbiayapermuser(
      id: json["id"] ?? "",

      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,

      itemkegiatan: json["itemkegiatan"] == null
          ? null
          : Itemkegiatan.fromJson(json["itemkegiatan"]),

      jumlahBiaya: double.tryParse(json["jumlah_biaya"].toString()) ?? 0,

      ketBiaya: json["ket_biaya"] ?? "",

      imageDkeluarbiayapermuser: json["image_dkeluarbiayapermuser"] ?? "",

      transpermohonan: json["transpermohonan"] == null
          ? null
          : Transpermohonan.fromJson(json["transpermohonan"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt?.toIso8601String(),
      "itemkegiatan": itemkegiatan?.toJson(),
      "jumlah_biaya": jumlahBiaya,
      "ket_biaya": ketBiaya,
      "image_dkeluarbiayapermuser": imageDkeluarbiayapermuser,
    };
  }

  Dkeluarbiayapermuser copyWith({
    String? id,
    DateTime? createdAt,
    Itemkegiatan? itemkegiatan,
    double? jumlahBiaya,
    String? ketBiaya,
    String? imageDkeluarbiayapermuser,
    Transpermohonan? transpermohonan,
  }) {
    return Dkeluarbiayapermuser(
      id: id ?? this.id,

      createdAt: createdAt ?? this.createdAt,

      itemkegiatan: itemkegiatan ?? this.itemkegiatan,

      jumlahBiaya: jumlahBiaya ?? this.jumlahBiaya,

      ketBiaya: ketBiaya ?? this.ketBiaya,

      imageDkeluarbiayapermuser:
          imageDkeluarbiayapermuser ?? this.imageDkeluarbiayapermuser,

      transpermohonan: transpermohonan ?? this.transpermohonan,
    );
  }

  bool get hasImage => imageDkeluarbiayapermuser.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    createdAt,
    itemkegiatan,
    jumlahBiaya,
    ketBiaya,
    imageDkeluarbiayapermuser,
    transpermohonan,
  ];
}

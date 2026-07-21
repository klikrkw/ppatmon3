import 'package:equatable/equatable.dart';

import 'itemkegiatan.dart';

class Dkeluarbiaya extends Equatable {
  final String id;

  final DateTime? createdAt;

  final Itemkegiatan? itemkegiatan;

  final double jumlahBiaya;

  final String ketBiaya;

  final String imageDkeluarbiaya;

  const Dkeluarbiaya({
    required this.id,
    required this.createdAt,
    required this.itemkegiatan,
    required this.jumlahBiaya,
    required this.ketBiaya,
    required this.imageDkeluarbiaya,
  });

  factory Dkeluarbiaya.fromJson(Map<String, dynamic> json) {
    return Dkeluarbiaya(
      id: json["id"] ?? "",

      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,

      itemkegiatan: json["itemkegiatan"] == null
          ? null
          : Itemkegiatan.fromJson(json["itemkegiatan"]),

      jumlahBiaya: double.tryParse(json["jumlah_biaya"].toString()) ?? 0,

      ketBiaya: json["ket_biaya"] ?? "",

      imageDkeluarbiaya: json["image_dkeluarbiaya"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt?.toIso8601String(),
      "itemkegiatan": itemkegiatan?.toJson(),
      "jumlah_biaya": jumlahBiaya,
      "ket_biaya": ketBiaya,
      "image_dkeluarbiaya": imageDkeluarbiaya,
    };
  }

  Dkeluarbiaya copyWith({
    String? id,
    DateTime? createdAt,
    Itemkegiatan? itemkegiatan,
    double? jumlahBiaya,
    String? ketBiaya,
    String? imageDkeluarbiaya,
  }) {
    return Dkeluarbiaya(
      id: id ?? this.id,

      createdAt: createdAt ?? this.createdAt,

      itemkegiatan: itemkegiatan ?? this.itemkegiatan,

      jumlahBiaya: jumlahBiaya ?? this.jumlahBiaya,

      ketBiaya: ketBiaya ?? this.ketBiaya,

      imageDkeluarbiaya: imageDkeluarbiaya ?? this.imageDkeluarbiaya,
    );
  }

  bool get hasImage => imageDkeluarbiaya.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    createdAt,
    itemkegiatan,
    jumlahBiaya,
    ketBiaya,
    imageDkeluarbiaya,
  ];
}

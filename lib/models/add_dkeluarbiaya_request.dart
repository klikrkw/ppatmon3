import 'dart:io';

class AddDkeluarbiayaRequest {
  final String keluarbiayaId;
  final int itemkegiatanId;
  final double jumlahBiaya;
  final String ketBiaya;
  final File? image;

  const AddDkeluarbiayaRequest({
    required this.keluarbiayaId,
    required this.itemkegiatanId,
    required this.jumlahBiaya,
    required this.ketBiaya,
    this.image,
  });

  Map<String, dynamic> toJson() => {
    'keluarbiaya_id': keluarbiayaId,
    'itemkegiatan_id': itemkegiatanId,
    'jumlah_biaya': jumlahBiaya,
    'ket_biaya': ketBiaya,
  };

  AddDkeluarbiayaRequest copyWith({
    String? keluarbiayaId,
    int? itemkegiatanId,
    double? jumlahBiaya,
    String? ketBiaya,
    File? image,
  }) => AddDkeluarbiayaRequest(
    keluarbiayaId: keluarbiayaId ?? this.keluarbiayaId,
    itemkegiatanId: itemkegiatanId ?? this.itemkegiatanId,
    jumlahBiaya: jumlahBiaya ?? this.jumlahBiaya,
    ketBiaya: ketBiaya ?? this.ketBiaya,
    image: image ?? this.image,
  );
}

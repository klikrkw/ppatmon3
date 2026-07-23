import 'dart:io';

class AddDKeluarbiayapermuserRequest {
  final String transpermohonanId;
  final String keluarbiayapermuserId;
  final int itemkegiatanId;
  final double jumlahBiaya;
  final String ketBiaya;
  final File? image;

  const AddDKeluarbiayapermuserRequest({
    required this.transpermohonanId,
    required this.keluarbiayapermuserId,
    required this.itemkegiatanId,
    required this.jumlahBiaya,
    required this.ketBiaya,
    this.image,
  });
}

import 'package:image_picker/image_picker.dart';

class AddDKeluarbiayapermuserRequest {
  final String transpermohonanId;
  final String keluarbiayapermuserId;
  final int itemkegiatanId;
  final double jumlahBiaya;
  final String ketBiaya;
  final XFile? image;

  const AddDKeluarbiayapermuserRequest({
    required this.transpermohonanId,
    required this.keluarbiayapermuserId,
    required this.itemkegiatanId,
    required this.jumlahBiaya,
    required this.ketBiaya,
    this.image,
  });
}

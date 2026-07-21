import 'package:image_picker/image_picker.dart';

class AddDkeluarbiayaRequest {
  final String keluarbiayaId;
  final int itemkegiatanId;
  final double jumlahBiaya;
  final String ketBiaya;
  final XFile? image;

  const AddDkeluarbiayaRequest({
    required this.keluarbiayaId,
    required this.itemkegiatanId,
    required this.jumlahBiaya,
    required this.ketBiaya,
    this.image,
  });
}

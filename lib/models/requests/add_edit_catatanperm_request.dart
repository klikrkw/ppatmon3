import 'dart:io';

class AddEditCatatanpermRequest {
  final int fieldcatatanId;
  final String transpermohonanId;
  final int userId;
  final String isiCatatanperm;
  final File? imageFile;

  const AddEditCatatanpermRequest({
    required this.fieldcatatanId,
    required this.transpermohonanId,
    required this.userId,
    required this.isiCatatanperm,
    this.imageFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'fieldcatatan_id': fieldcatatanId,
      'transpermohonan_id': transpermohonanId,
      'user_id': userId,
      'isi_catatanperm': isiCatatanperm,
      'image_file': imageFile,
    };
  }
}

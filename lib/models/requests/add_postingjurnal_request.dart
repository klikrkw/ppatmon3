import 'dart:io';

class AddPostingjurnalRequest {
  final String uraian;
  final int akunDebet;
  final int akunKredit;
  final double jumlah;
  final File? imageFile;

  const AddPostingjurnalRequest({
    required this.uraian,
    required this.akunDebet,
    required this.akunKredit,
    required this.jumlah,
    this.imageFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'uraian': uraian,
      'akun_debet': akunDebet,
      'akun_kredit': akunKredit,
      'jumlah': jumlah,
    };
  }

  AddPostingjurnalRequest copyWith({
    String? uraian,
    int? akunDebet,
    int? akunKredit,
    double? jumlah,
    File? imageFile,
  }) {
    return AddPostingjurnalRequest(
      uraian: uraian ?? this.uraian,
      akunDebet: akunDebet ?? this.akunDebet,
      akunKredit: akunKredit ?? this.akunKredit,
      jumlah: jumlah ?? this.jumlah,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  @override
  String toString() {
    return 'AddPostingjurnalRequest('
        'uraian: $uraian, '
        'akunDebet: $akunDebet, '
        'akunKredit: $akunKredit, '
        'jumlah: $jumlah, '
        'imageFile: ${imageFile?.path}'
        ')';
  }
}

import 'dart:io';

class UpdatePostingjurnalRequest {
  final String uraian;
  final int akunDebet;
  final int akunKredit;
  final double jumlah;
  final File? imageFile;

  const UpdatePostingjurnalRequest({
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

  UpdatePostingjurnalRequest copyWith({
    String? uraian,
    int? akunDebet,
    int? akunKredit,
    double? jumlah,
    File? imageFile,
  }) {
    return UpdatePostingjurnalRequest(
      uraian: uraian ?? this.uraian,
      akunDebet: akunDebet ?? this.akunDebet,
      akunKredit: akunKredit ?? this.akunKredit,
      jumlah: jumlah ?? this.jumlah,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  @override
  String toString() {
    return 'UpdatePostingjurnalRequest('
        'uraian: $uraian, '
        'akunDebet: $akunDebet, '
        'akunKredit: $akunKredit, '
        'jumlah: $jumlah, '
        'imageFile: ${imageFile?.path}'
        ')';
  }
}

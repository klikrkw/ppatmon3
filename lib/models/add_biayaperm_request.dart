import 'dart:io';

class AddBiayapermRequest {
  final String transpermohonanId;

  final double jumlahBiayaperm;
  final double jumlahBayar;
  final double jumlahKeluar;
  final double kurangBayar;

  final String catatanBiayaperm;

  // final String imageBiayaperm;
  final File? imageFile;
  final String? rincianbiayapermId;

  /// upload file
  /// edit, jika gambar lama tidak diganti
  final String? imageUrl;

  const AddBiayapermRequest({
    required this.transpermohonanId,
    required this.jumlahBiayaperm,
    required this.jumlahKeluar,
    required this.jumlahBayar,
    required this.kurangBayar,
    required this.catatanBiayaperm,
    this.imageFile,
    this.imageUrl,
    this.rincianbiayapermId,
  });

  Map<String, dynamic> toJson() {
    return {
      'transpermohonan_id': transpermohonanId,
      'jumlah_biayaperm': jumlahBiayaperm,
      'jumlah_keluar': jumlahKeluar,
      'jumlah_bayar': jumlahBayar,
      'kurang_bayar': kurangBayar,
      'catatan_biayaperm': catatanBiayaperm,
      // 'image_biayaperm': imageBiayaperm,
      'rincianbiayaperm_id': rincianbiayapermId,
      'image_file': imageFile,
    };
  }
}

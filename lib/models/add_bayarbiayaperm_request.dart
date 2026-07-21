import 'package:image_picker/image_picker.dart';

class AddBayarbiayapermRequest {
  final String biayapermId;

  // final DateTime tglBayarbiayaperm;

  final int metodebayarId;

  final int rekeningId;

  final double jumlahBayar;
  final double saldoAwal;
  final double saldoAkhir;

  final String catatanBayarbiayaperm;

  /// Gambar baru yang dipilih dari galeri/kamera
  final XFile? imageFile;

  /// URL/path gambar lama (dipakai saat edit)
  final String? imageUrl;

  const AddBayarbiayapermRequest({
    required this.biayapermId,
    // required this.tglBayarbiayaperm,
    required this.metodebayarId,
    required this.rekeningId,
    required this.jumlahBayar,
    required this.catatanBayarbiayaperm,
    required this.saldoAwal,
    required this.saldoAkhir,
    this.imageFile,
    this.imageUrl,
  });

  AddBayarbiayapermRequest copyWith({
    String? biayapermId,
    DateTime? tglBayarbiayaperm,
    int? metodebayarId,
    int? rekeningId,
    double? saldoAwal,
    double? jumlahBayar,
    double? saldoAkhir,
    String? catatanBayarbiayaperm,
    XFile? imageFile,
    String? imageUrl,
  }) {
    return AddBayarbiayapermRequest(
      biayapermId: biayapermId ?? this.biayapermId,
      // tglBayarbiayaperm: tglBayarbiayaperm ?? this.tglBayarbiayaperm,
      metodebayarId: metodebayarId ?? this.metodebayarId,
      rekeningId: rekeningId ?? this.rekeningId,
      jumlahBayar: jumlahBayar ?? this.jumlahBayar,
      catatanBayarbiayaperm:
          catatanBayarbiayaperm ?? this.catatanBayarbiayaperm,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      saldoAwal: saldoAwal ?? this.saldoAwal,
      saldoAkhir: saldoAkhir ?? this.saldoAkhir,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'biayaperm_id': biayapermId,
      // 'tgl_bayarbiayaperm': tglBayarbiayaperm.toIso8601String(),
      'metodebayar_id': metodebayarId,
      'rekening_id': rekeningId,
      'jumlah_bayar': jumlahBayar,
      'catatan_bayarbiayaperm': catatanBayarbiayaperm,
      'image_bayarbiayaperm': imageUrl,
      'saldo_awal': saldoAwal,
      'saldo_akhir': saldoAkhir,
    };
  }
}

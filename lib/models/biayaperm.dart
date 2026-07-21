import 'package:newklikrkw/models/rincianbiayaperm.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/models/user.dart';

class Biayaperm {
  final String id;
  final DateTime createdAt;

  final double jumlahBiayaperm;
  final double jumlahBayar;
  final double kurangBayar;
  final double jumlahKeluar;

  final String catatanBiayaperm;
  final String imageBiayaperm;

  final User user;
  final Transpermohonan transpermohonan;
  final List<Rincianbiayaperm> rincianbiayaperms; // Rincianbiayaperm
  bool get isLunas => kurangBayar == 0;

  const Biayaperm({
    required this.id,
    required this.createdAt,
    required this.jumlahBiayaperm,
    required this.jumlahKeluar,
    required this.jumlahBayar,
    required this.kurangBayar,
    required this.catatanBiayaperm,
    required this.imageBiayaperm,
    required this.user,
    required this.transpermohonan,
    required this.rincianbiayaperms,
  });

  factory Biayaperm.fromJson(Map<String, dynamic> json) {
    return Biayaperm(
      id: json['id'] ?? '',

      createdAt: DateTime.parse(json['created_at']),

      jumlahBiayaperm: (json['jumlah_biayaperm'] ?? 0).toDouble(),

      jumlahBayar: (json['jumlah_bayar'] ?? 0).toDouble(),
      jumlahKeluar: (json['jumlah_keluar'] ?? 0).toDouble(),

      kurangBayar: (json['kurang_bayar'] ?? 0).toDouble(),

      catatanBiayaperm: json['catatan_biayaperm'] ?? '',

      imageBiayaperm: json['image_biayaperm'] ?? '',

      user: User.fromJson(json['user'] ?? {}),

      transpermohonan: Transpermohonan.fromJson(json['transpermohonan'] ?? {}),
      rincianbiayaperms:
          (json['rincianbiayaperms'] as List?)
              ?.map((e) => Rincianbiayaperm.fromJson(e))
              .toList() ??
          [],
    );
  }
}

import 'package:equatable/equatable.dart';

class KodeAkun extends Equatable {
  final int id;
  final String kodeAkun;
  final String namaAkun;

  const KodeAkun({
    required this.id,
    required this.kodeAkun,
    required this.namaAkun,
  });

  factory KodeAkun.fromJson(Map<String, dynamic> json) {
    return KodeAkun(
      id: json['id'] ?? 0,
      kodeAkun: json['kode_akun'] ?? '',
      namaAkun: json['nama_akun'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, kodeAkun, namaAkun];
}

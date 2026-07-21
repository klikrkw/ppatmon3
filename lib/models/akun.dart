import 'package:equatable/equatable.dart';

class Akun extends Equatable {
  final int id;
  final String kodeAkun;
  final String namaAkun;

  const Akun({
    required this.id,
    required this.kodeAkun,
    required this.namaAkun,
  });

  factory Akun.fromJson(Map<String, dynamic> json) {
    return Akun(
      id: json['id'] ?? 0,
      kodeAkun: json['kode_akun'] ?? '',
      namaAkun: json['nama_akun'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, kodeAkun, namaAkun];
}

import 'package:equatable/equatable.dart';

import 'user.dart';

class Postingjurnal extends Equatable {
  final String id;

  final DateTime? createdAt;

  final User? user;

  final int akunDebet;

  final int akunKredit;

  final String uraian;

  final String image;

  final double jumlah;

  const Postingjurnal({
    required this.id,
    this.createdAt,
    this.user,
    required this.akunDebet,
    required this.akunKredit,
    required this.uraian,
    required this.image,
    required this.jumlah,
  });

  factory Postingjurnal.fromJson(Map<String, dynamic> json) {
    return Postingjurnal(
      id: json["id"] ?? "",

      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),

      user: json["user"] == null ? null : User.fromJson(json["user"]),

      akunDebet: (json["akun_debet"] ?? 0) as int,

      akunKredit: (json["akun_kredit"] ?? 0) as int,

      uraian: json["uraian"] ?? "",

      image: json["image"] ?? "",

      jumlah: (json["jumlah"] ?? 0).toDouble(),
    );
  }

  bool get hasImage => image.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    createdAt,
    user,
    akunDebet,
    akunKredit,
    uraian,
    image,
    jumlah,
  ];
}

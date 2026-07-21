import 'package:equatable/equatable.dart';

class Itemkegiatan extends Equatable {
  final int id;
  final String namaItemkegiatan;

  const Itemkegiatan({required this.id, required this.namaItemkegiatan});

  factory Itemkegiatan.fromJson(Map<String, dynamic> json) {
    return Itemkegiatan(
      id: json["id"] ?? 0,
      namaItemkegiatan: json["nama_itemkegiatan"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "nama_itemkegiatan": namaItemkegiatan};
  }

  Itemkegiatan copyWith({int? id, String? namaItemkegiatan}) {
    return Itemkegiatan(
      id: id ?? this.id,
      namaItemkegiatan: namaItemkegiatan ?? this.namaItemkegiatan,
    );
  }

  @override
  List<Object?> get props => [id, namaItemkegiatan];
}
